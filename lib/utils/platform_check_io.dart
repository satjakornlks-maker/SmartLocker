import 'dart:io';

bool get isDesktop =>
    Platform.isWindows || Platform.isMacOS || Platform.isLinux;

bool get isAndroid => Platform.isAndroid;

void exitApp(int code) => exit(code);
