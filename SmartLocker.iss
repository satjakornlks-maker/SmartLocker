; ============================================================
;  SmartLocker - Inno Setup Script
;  Build the release first:
;    flutter build windows --release
;  Then compile this script with Inno Setup Compiler.
; ============================================================

#define AppName      "SmartLocker"
#define AppVersion   "1.0.0"
#define AppPublisher "SmartLocker"
#define AppExeName   "untitled.exe"
#define BuildDir     "build\windows\x64\runner\Release"

[Setup]
AppId={{F3A2B1C4-8E5D-4F6A-9B2C-1D3E4F5A6B7C}
AppName={#AppName}
AppVersion={#AppVersion}
AppPublisherURL=
AppSupportURL=
AppUpdatesURL=
DefaultDirName={autopf}\{#AppName}
DefaultGroupName={#AppName}
DisableProgramGroupPage=yes
OutputDir=installer
OutputBaseFilename=SmartLocker_Setup_{#AppVersion}
SetupIconFile=windows\runner\resources\app_icon.ico
Compression=lzma2/ultra64
SolidCompression=yes
WizardStyle=modern
PrivilegesRequired=admin
; Prevent running multiple instances
AppMutex=SmartLockerAppMutex

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Tasks]
Name: "desktopicon";    Description: "{cm:CreateDesktopIcon}";    GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked
Name: "autostart";      Description: "Start SmartLocker automatically when Windows starts"; GroupDescription: "Startup:"; Flags: unchecked

[Files]
; Main executable
Source: "{#BuildDir}\{#AppExeName}";          DestDir: "{app}"; Flags: ignoreversion

; Flutter runtime DLLs
Source: "{#BuildDir}\flutter_windows.dll";                    DestDir: "{app}"; Flags: ignoreversion
Source: "{#BuildDir}\screen_retriever_windows_plugin.dll";    DestDir: "{app}"; Flags: ignoreversion
Source: "{#BuildDir}\window_manager_plugin.dll";              DestDir: "{app}"; Flags: ignoreversion

; App data folder (assets, fonts, etc.)
Source: "{#BuildDir}\data\*"; DestDir: "{app}\data"; Flags: ignoreversion recursesubdirs createallsubdirs

; config.json — copied but NOT overwritten on reinstall so user config is preserved
Source: "{#BuildDir}\config.json"; DestDir: "{app}"; Flags: ignoreversion onlyifdoesntexist

[Icons]
; Start Menu shortcut
Name: "{group}\{#AppName}";           Filename: "{app}\{#AppExeName}"; IconFilename: "{app}\{#AppExeName}"
Name: "{group}\Uninstall {#AppName}"; Filename: "{uninstallexe}"

; Desktop shortcut (optional task)
Name: "{autodesktop}\{#AppName}"; Filename: "{app}\{#AppExeName}"; IconFilename: "{app}\{#AppExeName}"; Tasks: desktopicon

[Registry]
; Auto-start on Windows boot (optional task)
Root: HKLM; Subkey: "SOFTWARE\Microsoft\Windows\CurrentVersion\Run"; ValueType: string; ValueName: "{#AppName}"; ValueData: """{app}\{#AppExeName}"""; Flags: uninsdeletevalue; Tasks: autostart

[Run]
; Launch the app after installation finishes
Filename: "{app}\{#AppExeName}"; Description: "{cm:LaunchProgram,{#StringChange(AppName, '&', '&&')}}"; Flags: nowait postinstall skipifsilent

[UninstallRun]
; Make sure the app is not running when uninstalling
Filename: "taskkill"; Parameters: "/F /IM {#AppExeName}"; Flags: runhidden; RunOnceId: "KillApp"

[Code]
// Kill any running instance before installing/upgrading
procedure KillRunningApp();
var
  ResultCode: Integer;
begin
  Exec('taskkill', '/F /IM {#AppExeName}', '', SW_HIDE, ewWaitUntilTerminated, ResultCode);
end;

function PrepareToInstall(var NeedsRestart: Boolean): String;
begin
  KillRunningApp();
  Result := '';
end;
