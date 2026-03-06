import 'dart:io';

bool get isDesktop =>
    Platform.isWindows || Platform.isMacOS || Platform.isLinux;
