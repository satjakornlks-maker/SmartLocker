import 'dart:async';
import 'package:flutter/material.dart';

/// Resets the app to the home route after a period of user inactivity.
///
/// Wrap the top of your widget tree in [InactivityWrapper] and the timer
/// restarts on any tap/drag anywhere in the app. After [timeout] with no
/// input, navigates to '/' and clears the navigation stack.
///
/// Usage:
///   home: InactivityWrapper(
///     timeout: Duration(minutes: 3),
///     child: MyHomePage(),
///   )
class InactivityWrapper extends StatefulWidget {
  final Widget child;
  final Duration timeout;
  final String resetRoute;
  final VoidCallback? onTimeout;

  const InactivityWrapper({
    super.key,
    required this.child,
    this.timeout = const Duration(minutes: 3),
    this.resetRoute = '/',
    this.onTimeout,
  });

  @override
  State<InactivityWrapper> createState() => _InactivityWrapperState();
}

class _InactivityWrapperState extends State<InactivityWrapper> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _resetTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _resetTimer() {
    _timer?.cancel();
    _timer = Timer(widget.timeout, _onInactive);
  }

  void _onInactive() {
    widget.onTimeout?.call();
    final nav = Navigator.of(context, rootNavigator: true);
    nav.pushNamedAndRemoveUntil(widget.resetRoute, (r) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerDown: (_) => _resetTimer(),
      onPointerMove: (_) => _resetTimer(),
      onPointerSignal: (_) => _resetTimer(),
      child: widget.child,
    );
  }
}
