// ignore_for_file: avoid_classes_with_only_static_members

import 'platform_web.dart' if (dart.library.io) 'platform_io.dart';

/// Class to check which is the current platform allow the compilation from
/// web/mobile/desktop
abstract class PlatformCheck {
  static bool get isWeb => currentPlatform == PlatformCheckType.web;
  static bool get isMacOS => currentPlatform == PlatformCheckType.macOS;
  static bool get isWindows => currentPlatform == PlatformCheckType.windows;
  static bool get isLinux => currentPlatform == PlatformCheckType.linux;
  static bool get isAndroid => currentPlatform == PlatformCheckType.android;
  static bool get isIOS => currentPlatform == PlatformCheckType.iOS;
}

enum PlatformCheckType { web, windows, linux, macOS, android, fuchsia, iOS }
