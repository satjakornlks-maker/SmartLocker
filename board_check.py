"""
CU16C Multi-Board Watcher with API Sync
Based on CU16C Protocol v5.2

Protocol (CU16C):
- Send frame: 6 bytes (02 ADDR LOCKNUM CMD 03 SUM)
- Response frame: 12 bytes (02 ADDR LOCKNUM CMD D1 D2 D3 D4 D5 D6 03 SUM)
- Command: 0x70 (status)
- Response: 0x85 (status)

Multi-HF Configuration:
  Option A (single HF, backward compatible):
    HF_IP=192.168.22.40
    HF_PORT=8899
    CU_ADDRESSES=0x01,0x02

  Option B (multiple HF converters):
    HF_CONNECTIONS=192.168.22.40:8899:0x01,0x02;192.168.22.41:8899:0x03,0x04
"""

import os
import sys
import socket
import time
import threading
import argparse
import requests
from dataclasses import dataclass
from datetime import datetime, timedelta
from typing import Dict, Optional, List
from pathlib import Path
from dotenv import load_dotenv

load_dotenv(Path(__file__).parent / '.env')

POLL_SEC = float(os.getenv("POLL_SEC", "0.3"))
SOCK_TIMEOUT = float(os.getenv("SOCK_TIMEOUT", "2.0"))
RESTART_HOUR = int(os.getenv("RESTART_HOUR", "0"))  # Hour of day to restart (0 = midnight)

# CU16C Command
CMD_STATUS = 0x70
RESP_STATUS = 0x85


def parse_cu_addresses(env_value: str) -> List[int]:
    """Parse comma-separated hex addresses like '0x01,0x02'"""
    if not env_value:
        return [0x01]
    addresses = []
    for addr in env_value.split(","):
        addr = addr.strip()
        if addr.startswith("0x") or addr.startswith("0X"):
            addresses.append(int(addr, 16))
        else:
            addresses.append(int(addr))
    return addresses


@dataclass
class HFConnection:
    """Represents a single HF converter with its CU addresses"""
    ip: str
    port: int
    cu_addresses: List[int]

    def __str__(self):
        cus = ",".join(f"0x{a:02X}" for a in self.cu_addresses)
        return f"{self.ip}:{self.port} -> [{cus}]"


def parse_hf_connections() -> List[HFConnection]:
    """
    Parse HF connection config from env.

    Option A (legacy, single HF):
        HF_IP=192.168.22.40
        HF_PORT=8899
        CU_ADDRESSES=0x01,0x02

    Option B (multi-HF):
        HF_CONNECTIONS=192.168.22.40:8899:0x01,0x02;192.168.22.41:8899:0x03,0x04
    """
    hf_connections_env = os.getenv("HF_CONNECTIONS", "")

    if hf_connections_env:
        connections = []
        for entry in hf_connections_env.split(";"):
            entry = entry.strip()
            if not entry:
                continue
            parts = entry.split(":")
            if len(parts) < 3:
                print(f"WARN: Invalid HF_CONNECTIONS entry: '{entry}' (expected ip:port:cu_addrs)")
                continue
            ip = parts[0].strip()
            port = int(parts[1].strip())
            cu_addrs = parse_cu_addresses(parts[2].strip())
            connections.append(HFConnection(ip=ip, port=port, cu_addresses=cu_addrs))
        if connections:
            return connections

    # Fallback to legacy single-HF config
    hf_ip = os.getenv("HF_IP", "192.168.22.40")
    hf_port = int(os.getenv("HF_PORT", "8899"))
    cu_addresses = parse_cu_addresses(os.getenv("CU_ADDRESSES", "0x01"))
    return [HFConnection(ip=hf_ip, port=hf_port, cu_addresses=cu_addresses)]


HF_CONNECTIONS = parse_hf_connections()

# Collect all CU addresses across all HF connections
ALL_CU_ADDRESSES = []
for conn in HF_CONNECTIONS:
    ALL_CU_ADDRESSES.extend(conn.cu_addresses)

# API Configuration
API_BASE_URL = os.getenv("API_BASE_URL", "")
API_KEY = os.getenv("API_KEY", "")

API_GET_LOCKER = f"{API_BASE_URL}/init/get_all_locker_unit"
API_UPDATE_STATUS = f"{API_BASE_URL}/Locker_status_update"
API_HEADERS = {
    "x-app-token": API_KEY,
    "Content-Type": "application/json"
}


# ============ Utility Functions ============

def ts() -> str:
    return datetime.now().strftime("%H:%M:%S.%f")[:-3]


def hexs(b: bytes) -> str:
    return " ".join(f"{x:02X}" for x in b)


def sum_low(b: bytes) -> int:
    return sum(b) & 0xFF


def build_frame(addr: int, locknum: int, cmd: int) -> bytes:
    """
    Build CU16C frame: 02 ADDR LOCKNUM CMD 03 SUM (6 bytes)
    """
    body = bytes([0x02, addr & 0xFF, locknum & 0xFF, cmd & 0xFF, 0x03])
    return body + bytes([sum_low(body)])


def recv_until_idle(sock: socket.socket, timeout: float = 2.0, idle_timeout: float = 0.25) -> Optional[bytes]:
    sock.settimeout(timeout)
    chunks = []
    while True:
        try:
            data = sock.recv(1024)
            if not data:
                break
            chunks.append(data)
            sock.settimeout(idle_timeout)
        except socket.timeout:
            break
    return b"".join(chunks) if chunks else None


def bits16(d_lo: int, d_hi: int) -> Dict[int, int]:
    """Convert two bytes to 16-channel status dict"""
    out: Dict[int, int] = {}
    for i in range(8):
        out[i + 1] = (d_lo >> i) & 1
        out[i + 9] = (d_hi >> i) & 1
    return out


def label_ir(v: int) -> str:
    return "OCCUPIED" if v == 1 else "EMPTY"


def label_lock(v: int) -> str:
    return "LOCKED" if v == 1 else "UNLOCKED"


def diff_channels(prev: Dict[int, int], cur: Dict[int, int]):
    changed = []
    for ch in range(1, 17):
        pv = prev.get(ch, 0)
        cv = cur.get(ch, 0)
        if pv != cv:
            changed.append((ch, pv, cv))
    return changed


# ============ CU16C Status Query ============

def query_status(sock: socket.socket, cu_addr: int) -> Optional[dict]:
    """
    Get status of single CU16C - command 0x70
    Send: 02 ADDR 00 70 03 SUM (6 bytes)
    Response: 02 ADDR LOCKNUM 85 D1 D2 D3 D4 D5 D6 03 SUM (12 bytes)
    
    D1: Hook status CH1-8 (1=locked, 0=unlocked)
    D2: Hook status CH9-16
    D3: IR status CH1-8 (1=occupied, 0=empty)
    D4: IR status CH9-16
    D5: Push door switch CH1-8
    D6: Push door switch CH9-16
    """
    pkt = build_frame(cu_addr, 0x00, CMD_STATUS)
    sock.sendall(pkt)
    raw = recv_until_idle(sock, timeout=SOCK_TIMEOUT, idle_timeout=0.25)
    
    if not raw:
        return None

    # Parse CU16C 12-byte response
    i = 0
    while i < len(raw) - 11:
        if raw[i] == 0x02 and raw[i + 3] == RESP_STATUS:
            addr = raw[i + 1]
            if addr != cu_addr:
                i += 1
                continue
                
            d1 = raw[i + 4]   # Hook 1-8
            d2 = raw[i + 5]   # Hook 9-16
            d3 = raw[i + 6]   # IR 1-8
            d4 = raw[i + 7]   # IR 9-16
            d5 = raw[i + 8]   # Push door 1-8
            d6 = raw[i + 9]   # Push door 9-16
            
            return {
                "raw": raw[i:i+12],
                "d1": d1, "d2": d2, "d3": d3, "d4": d4, "d5": d5, "d6": d6,
                "lock": bits16(d1, d2),
                "ir": bits16(d3, d4),
            }
        else:
            i += 1
    
    return None


# ============ IR Sensor Check Functions ============

def check_ir_each_channel(sock: socket.socket, cu_addr: int) -> Dict[int, str]:
    """Check each IR sensor channel"""
    st = query_status(sock, cu_addr)
    
    if not st:
        return {ch: 'NO_DATA' for ch in range(1, 17)}
    
    results = {}
    for ch in range(1, 17):
        results[ch] = 'DETECTED' if st["ir"][ch] == 1 else 'EMPTY'
    
    return results


def print_all_boards_ir_status(sock: socket.socket, cu_addresses: List[int]):
    """Print IR status of all boards"""
    print(f"\n[{ts()}] {'='*50}")
    print(f"[{ts()}] ALL BOARDS IR STATUS CHECK")
    print(f"[{ts()}] {'='*50}")
    
    for cu_addr in cu_addresses:
        status = check_ir_each_channel(sock, cu_addr)
        
        detected = [ch for ch, val in status.items() if val == 'DETECTED']
        empty = [ch for ch, val in status.items() if val == 'EMPTY']
        no_data = [ch for ch, val in status.items() if val == 'NO_DATA']
        
        if no_data and len(no_data) == 16:
            print(f"[{ts()}] CU 0x{cu_addr:02X}: ✗ NO DATA (board offline?)")
        else:
            print(f"[{ts()}] CU 0x{cu_addr:02X}: DETECTED={detected or 'none'} | EMPTY={len(empty)} channels")
    
    print(f"[{ts()}] {'='*50}\n")


def initial_ir_check(sock: socket.socket, cu_addresses: List[int]) -> bool:
    """Initial check of all IR sensors"""
    print(f"\n[{ts()}] Initial IR Sensor Check (CU16C Protocol 0x70)")
    print("=" * 50)
    
    any_connected = False
    
    for cu_addr in cu_addresses:
        print(f"\nCU 0x{cu_addr:02X}:")
        status = check_ir_each_channel(sock, cu_addr)
        
        has_data = False
        for ch in range(1, 17):
            if status[ch] == 'NO_DATA':
                icon = '✗'
            elif status[ch] == 'DETECTED':
                icon = '✓'
                has_data = True
            else:
                icon = '○'
                has_data = True
            print(f"  CH{ch:02d}: {icon} {status[ch]}")
        
        if has_data:
            any_connected = True
            print(f"  >>> Board 0x{cu_addr:02X}: ONLINE")
        else:
            print(f"  >>> Board 0x{cu_addr:02X}: OFFLINE or NO RESPONSE")
    
    print("=" * 50)
    return any_connected


# ============ API Functions ============

def fetch_locker_data() -> Optional[dict]:
    try:
        response = requests.get(API_GET_LOCKER, headers=API_HEADERS, timeout=5)
        print(f"[{ts()}] API GET response: {response.status_code}")
        if response.status_code == 200:
            return response.json()
        print(f"[{ts()}] API GET failed: {response.status_code} - {response.text}")
    except requests.RequestException as e:
        print(f"[{ts()}] API GET error: {e}")
    return None


def build_locker_map_for_all_cus(api_data, cu_addresses: List[int]) -> Dict[int, Dict[int, dict]]:
    """
    Build a mapping for all CUs: cu_addr -> {channel_number -> locker info}
    
    API returns flat array:
    [
      { "id": 1, "name": "...", "cuNumber": 1, "cuId": 5, "cuCode": "0x01", ... },
      ...
    ]
    """
    all_locker_maps = {}
    
    # api_data is now a list, not a dict
    lockers = api_data if isinstance(api_data, list) else []
    
    for cu_addr in cu_addresses:
        cu_code = f"0x{cu_addr:02X}"
        locker_map = {}
        
        for locker in lockers:
            # Match by cuCode if available, otherwise try to match by cuId
            locker_cu_code = locker.get("cuCode")
            
            if locker_cu_code and locker_cu_code == cu_code:
                ch = locker.get("cuNumber")
                if ch is not None:
                    locker_map[int(ch)] = locker
            elif not locker_cu_code:
                # Fallback: if no cuCode, user needs to configure CU_ID_MAP
                print(f"[{ts()}] WARN: Locker '{locker.get('name')}' has no cuCode - add cuCode to API response")
        
        all_locker_maps[cu_addr] = locker_map
        print(f"[{ts()}] Loaded {len(locker_map)} lockers for CU {cu_code}")
    
    return all_locker_maps


def update_locker_status_api(
    locker_unit_id: int,
    status: str,
    occupied: bool,
    cu_code: str = None,
    alert_type: str = None,
    alert_message: str = None,
) -> bool:
    try:
        payload = {
            "LockerUnitID": locker_unit_id,
            "enable": True,
            "status": status,
            "cuStatus": True,
            "has_item": occupied,
            "CU_code": cu_code,
            "type": alert_type,
            "message": alert_message,
            "is_read": False,
        }
        response = requests.post(API_UPDATE_STATUS, json=payload, headers=API_HEADERS, timeout=5)
        if response.status_code == 200:
            return True
        print(f"[{ts()}] API POST failed: {response.status_code} - {response.text}")
    except requests.RequestException as e:
        print(f"[{ts()}] API POST error: {e}")
    return False


def notify_board_offline(locker_map: Dict[int, dict], cu_addr: int, alert_type: str = None, alert_message: str = None):
    """Notify the backend API that a board is offline / connection failed."""
    if not locker_map:
        print(f"[{ts()}] WARN: No locker map for CU 0x{cu_addr:02X}, cannot notify API of offline status")
        return

    for ch, locker in locker_map.items():
        locker_id = locker.get("id")
        locker_name = locker.get("name", f"CU{cu_addr:02X}-CH{ch}")
        try:
            payload = {
                "LockerUnitID": locker_id,
                "CU_code": f"0x{cu_addr:02X}",
                "enable": False,
                "cuStatus": False,
                "has_item": locker.get("has_item", False),
                "type": alert_type,
                "message": alert_message,
                "is_read": False,
            }
            response = requests.post(API_UPDATE_STATUS, json=payload, headers=API_HEADERS, timeout=5)
            if response.status_code == 200:
                print(f"[{ts()}] API: {locker_name} (ID:{locker_id}) reported OFFLINE")
            else:
                print(f"[{ts()}] API offline report failed for {locker_name}: {response.status_code}")
        except requests.RequestException as e:
            print(f"[{ts()}] API offline report error for {locker_name}: {e}")


def sync_status_to_api(locker_map: Dict[int, dict], cu_addr: int, ch: int, ir_value: int, lock_value: int):
    if ch not in locker_map:
        return

    locker = locker_map[ch]
    locker_id = locker.get("id")
    locker_name = locker.get("name", f"CU{cu_addr:02X}-CH{ch}")

    occupied = ir_value == 1
    new_status = "open" if lock_value == 0 else "close"
    
    # Track last synced status locally (API status field means "is booked", not lock status)
    db_status = locker.get("_synced_status", "")

    if new_status != db_status:
        cu_code = f"0x{cu_addr:02X}"
        if update_locker_status_api(locker_id, new_status, occupied, cu_code):
            print(f"[{ts()}] API: {locker_name} (ID:{locker_id}) status -> {new_status}, has_item -> {occupied}, CU -> {cu_code} ONLINE")
            locker["_synced_status"] = new_status


# ============ Board State Class ============

class BoardState:
    """Track state for a single board"""
    def __init__(self, cu_addr: int):
        self.cu_addr = cu_addr
        self.prev_ir: Dict[int, int] = {}
        self.prev_lock: Dict[int, int] = {}
        self.initialized = False


# ============ Per-HF Watcher ============

def run_hf_watcher(hf_conn: HFConnection, all_locker_maps: Dict[int, Dict[int, dict]], stop_event: threading.Event):
    """
    Run the polling loop for a single HF converter and its CU addresses.
    Each HF connection runs in its own thread with its own socket.
    """
    label = f"HF({hf_conn.ip}:{hf_conn.port})"
    cu_addresses = hf_conn.cu_addresses

    # Step 1: Initial IR sensor check
    try:
        with socket.create_connection((hf_conn.ip, hf_conn.port), timeout=5) as sock:
            boards_ok = initial_ir_check(sock, cu_addresses)

            if not boards_ok:
                print(f"\n[{ts()}] {label} ERROR: No boards responding. Notifying API...")
                for cu_addr in cu_addresses:
                    notify_board_offline(
                        all_locker_maps.get(cu_addr, {}), cu_addr,
                        alert_type="cu_offline",
                        alert_message=f"CU 0x{cu_addr:02X} not responding on {hf_conn.ip}:{hf_conn.port}",
                    )
                return

            print(f"\n[{ts()}] {label} IR sensor check passed. Continuing...\n")
    except Exception as e:
        print(f"[{ts()}] {label} Connection failed: {e}")
        for cu_addr in cu_addresses:
            notify_board_offline(
                all_locker_maps.get(cu_addr, {}), cu_addr,
                alert_type="hf_offline",
                alert_message=f"HF converter {hf_conn.ip}:{hf_conn.port} cannot connect: {e}",
            )
        return

    # Step 2: Persistent polling with auto-reconnect
    board_states = {addr: BoardState(addr) for addr in cu_addresses}
    fail_counts: Dict[int, int] = {addr: 0 for addr in cu_addresses}
    FAIL_THRESHOLD = 3
    reported_offline: Dict[int, bool] = {addr: False for addr in cu_addresses}
    HEARTBEAT_SEC = 60
    API_RETRY_SEC = 30
    RECONNECT_DELAY = 5
    last_heartbeat = time.time()
    last_api_retry = time.time()

    while not stop_event.is_set():
        # --- Connect ---
        try:
            s = socket.create_connection((hf_conn.ip, hf_conn.port), timeout=5)
            print(f"[{ts()}] {label} Polling socket connected")
        except Exception as e:
            print(f"[{ts()}] {label} Polling connection failed: {e} — retrying in {RECONNECT_DELAY}s")
            for cu_addr in cu_addresses:
                notify_board_offline(
                    all_locker_maps.get(cu_addr, {}), cu_addr,
                    alert_type="hf_offline",
                    alert_message=f"HF converter {hf_conn.ip}:{hf_conn.port} cannot connect: {e}",
                )
            time.sleep(RECONNECT_DELAY)
            continue

        try:
            # Initial read for uninitialized boards
            for cu_addr in cu_addresses:
                board = board_states[cu_addr]
                if board.initialized:
                    continue  # keep state across reconnects
                st = query_status(s, cu_addr)
                if not st:
                    print(f"[{ts()}] {label} WARN: No reply from CU 0x{cu_addr:02X}")
                    continue
                board.prev_ir = st["ir"]
                board.prev_lock = st["lock"]
                board.initialized = True
                print(f"[{ts()}] {label} CU 0x{cu_addr:02X} START IR=   {', '.join(f'{ch}:{board.prev_ir[ch]}' for ch in range(1,17))}")
                print(f"[{ts()}] {label} CU 0x{cu_addr:02X} START LOCK= {', '.join(f'{ch}:{board.prev_lock[ch]}' for ch in range(1,17))}")
                locker_map = all_locker_maps.get(cu_addr, {})
                if locker_map:
                    for ch in range(1, 17):
                        if ch in locker_map:
                            sync_status_to_api(locker_map, cu_addr, ch, board.prev_ir[ch], board.prev_lock[ch])
                time.sleep(0.1)
            print()

            # --- Main polling loop ---
            while not stop_event.is_set():
                now = time.time()

                if now - last_heartbeat >= HEARTBEAT_SEC:
                    for cu_addr in cu_addresses:
                        board = board_states[cu_addr]
                        if board.initialized:
                            locked_chs = [ch for ch, v in board.prev_lock.items() if v == 1]
                            occupied_chs = [ch for ch, v in board.prev_ir.items() if v == 1]
                            print(f"[{ts()}] {label} ♥ CU 0x{cu_addr:02X} ALIVE | "
                                  f"locked={locked_chs or 'none'} | occupied={occupied_chs or 'none'}")
                    last_heartbeat = now

                missing = [a for a in cu_addresses if not all_locker_maps.get(a)]
                if missing and now - last_api_retry >= API_RETRY_SEC:
                    print(f"[{ts()}] {label} Retrying API locker map for {[f'0x{a:02X}' for a in missing]}...")
                    api_data = fetch_locker_data()
                    if api_data:
                        new_maps = build_locker_map_for_all_cus(api_data, missing)
                        for cu_addr, lmap in new_maps.items():
                            if lmap:
                                all_locker_maps[cu_addr] = lmap
                                print(f"[{ts()}] {label} Loaded {len(lmap)} lockers for CU 0x{cu_addr:02X} — syncing initial status...")
                                board = board_states.get(cu_addr)
                                if board and board.initialized:
                                    for ch in range(1, 17):
                                        if ch in lmap:
                                            sync_status_to_api(lmap, cu_addr, ch, board.prev_ir[ch], board.prev_lock[ch])
                    else:
                        print(f"[{ts()}] {label} API still unreachable, will retry in {API_RETRY_SEC}s")
                    last_api_retry = time.time()

                for cu_addr in cu_addresses:
                    board = board_states[cu_addr]
                    if not board.initialized:
                        continue

                    st2 = query_status(s, cu_addr)
                    if not st2:
                        fail_counts[cu_addr] += 1
                        print(f"[{ts()}] {label} WARN: CU 0x{cu_addr:02X} timeout/no data (fail {fail_counts[cu_addr]}/{FAIL_THRESHOLD})")
                        if fail_counts[cu_addr] >= FAIL_THRESHOLD and not reported_offline[cu_addr]:
                            print(f"[{ts()}] {label} CU 0x{cu_addr:02X} appears OFFLINE, notifying API...")
                            notify_board_offline(
                                all_locker_maps.get(cu_addr, {}), cu_addr,
                                alert_type="cu_offline",
                                alert_message=f"CU 0x{cu_addr:02X} stopped responding ({FAIL_THRESHOLD} consecutive timeouts)",
                            )
                            reported_offline[cu_addr] = True
                        continue

                    if fail_counts[cu_addr] > 0 or reported_offline[cu_addr]:
                        if reported_offline[cu_addr]:
                            print(f"[{ts()}] {label} CU 0x{cu_addr:02X} is back ONLINE")
                        fail_counts[cu_addr] = 0
                        reported_offline[cu_addr] = False

                    cur_ir = st2["ir"]
                    cur_lock = st2["lock"]
                    ir_changes = diff_channels(board.prev_ir, cur_ir)
                    lock_changes = diff_channels(board.prev_lock, cur_lock)
                    locker_map = all_locker_maps.get(cu_addr, {})

                    if ir_changes or lock_changes:
                        for ch, pv, cv in ir_changes:
                            print(f"[{ts()}] {label} CU 0x{cu_addr:02X} IR   CH{ch:02d}: {pv} -> {cv}   ({label_ir(cv)})")
                            if locker_map:
                                sync_status_to_api(locker_map, cu_addr, ch, cv, cur_lock[ch])
                        for ch, pv, cv in lock_changes:
                            print(f"[{ts()}] {label} CU 0x{cu_addr:02X} LOCK CH{ch:02d}: {pv} -> {cv}   ({label_lock(cv)})")
                            if locker_map:
                                sync_status_to_api(locker_map, cu_addr, ch, cur_ir[ch], cv)
                        raw = st2["raw"]
                        print(f"[{ts()}] {label} CU 0x{cu_addr:02X} RAW  {hexs(raw)}")
                        print_all_boards_ir_status(s, cu_addresses)

                    board.prev_ir = cur_ir
                    board.prev_lock = cur_lock
                    time.sleep(0.05)

                time.sleep(POLL_SEC)

        except (ConnectionError, OSError) as e:
            print(f"[{ts()}] {label} Connection lost: {e} — reconnecting in {RECONNECT_DELAY}s")
            for cu_addr in cu_addresses:
                notify_board_offline(
                    all_locker_maps.get(cu_addr, {}), cu_addr,
                    alert_type="hf_offline",
                    alert_message=f"HF converter {hf_conn.ip}:{hf_conn.port} connection lost: {e}",
                )
        finally:
            try:
                s.close()
            except Exception:
                pass

        if not stop_event.is_set():
            time.sleep(RECONNECT_DELAY)

    print(f"[{ts()}] {label} Watcher stopped.")


# ============ Daily Restart ============

def daily_restart_watcher(stop_event: threading.Event):
    """Wait until RESTART_HOUR each day, then restart the process."""
    now = datetime.now()
    target = now.replace(hour=RESTART_HOUR, minute=0, second=0, microsecond=0)
    if target <= now:
        target += timedelta(days=1)

    wait_secs = (target - now).total_seconds()
    print(f"[{ts()}] Daily restart scheduled at {target.strftime('%Y-%m-%d %H:%M:%S')} (in {wait_secs / 3600:.1f}h)")

    while wait_secs > 0 and not stop_event.is_set():
        chunk = min(wait_secs, 60)
        time.sleep(chunk)
        wait_secs -= chunk

    if not stop_event.is_set():
        print(f"[{ts()}] Daily restart triggered. Restarting process...")
        os.execv(sys.executable, [sys.executable] + sys.argv)


# ============ Parent Process Monitor ============

def _monitor_parent(parent_pid: int, stop_event: threading.Event):
    """Exit this process if the parent Flutter process disappears."""
    while not stop_event.is_set():
        try:
            os.kill(parent_pid, 0)  # 0 = existence check only, no signal sent
        except ProcessLookupError:
            print(f"[{ts()}] Parent process (PID {parent_pid}) is gone — shutting down")
            os._exit(1)
        except PermissionError:
            pass  # Process exists but no permission to signal — fine
        time.sleep(2)


# ============ Main Function ============

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--parent-pid', type=int, default=None,
                        help='PID of the Flutter parent process to co-monitor')
    args = parser.parse_args()

    print("=" * 60)
    print("CU16C Multi-Board Watcher with API Sync")
    print("Protocol: CU16C v5.2 (Command 0x70)")
    print("=" * 60)
    print(f"HF Connections: {len(HF_CONNECTIONS)}")
    for i, conn in enumerate(HF_CONNECTIONS):
        print(f"  [{i+1}] {conn}")
    print(f"Total CUs: {[f'0x{addr:02X}' for addr in ALL_CU_ADDRESSES]}")
    print(f"Poll interval: {POLL_SEC}s")
    print(f"API: {API_BASE_URL}")

    # Fetch locker data from API (shared across all HF connections)
    api_data = fetch_locker_data()
    all_locker_maps: Dict[int, Dict[int, dict]] = {}

    if api_data:
        all_locker_maps = build_locker_map_for_all_cus(api_data, ALL_CU_ADDRESSES)
        print()
        for cu_addr, locker_map in all_locker_maps.items():
            print(f"CU 0x{cu_addr:02X} lockers:")
            for ch, locker in sorted(locker_map.items()):
                occupier = locker.get('occupier') or 'vacant'
                print(f"  CH{ch:02d} -> {locker.get('name')} (ID:{locker.get('id')}, occupier:{occupier})")
        print()
    else:
        print(f"[{ts()}] WARN: Could not fetch locker data from API\n")

    print("Press Ctrl+C to stop.\n")

    # Launch one thread per HF connection
    stop_event = threading.Event()
    threads: List[threading.Thread] = []

    if args.parent_pid:
        parent_thread = threading.Thread(
            target=_monitor_parent,
            args=(args.parent_pid, stop_event),
            daemon=True,
            name="ParentMonitor",
        )
        parent_thread.start()
        print(f"[{ts()}] Monitoring parent Flutter process (PID {args.parent_pid})")

    restart_thread = threading.Thread(target=daily_restart_watcher, args=(stop_event,), daemon=True, name="DailyRestart")
    restart_thread.start()

    for hf_conn in HF_CONNECTIONS:
        t = threading.Thread(
            target=run_hf_watcher,
            args=(hf_conn, all_locker_maps, stop_event),
            name=f"HF-{hf_conn.ip}:{hf_conn.port}",
            daemon=True,
        )
        threads.append(t)
        t.start()

    # Wait for all threads (Ctrl+C will interrupt)
    try:
        while any(t.is_alive() for t in threads):
            time.sleep(0.5)
    except KeyboardInterrupt:
        print(f"\n[{ts()}] Shutting down all watchers...")
        stop_event.set()
        for t in threads:
            t.join(timeout=5)

    print("All watchers stopped.")


if __name__ == "__main__":
    main()