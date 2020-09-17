import 'dart:async';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:kd_scanner/method_channel_kd_scanner.dart';


abstract class KdScannerPlatform extends PlatformInterface {
    KdScannerPlatform() : super(token: _token);

  static final Object _token = Object();

  static KdScannerPlatform _instance = MethodChannelKdScanner();

  /// The default instance of [UrlLauncherPlatform] to use.
  ///
  /// Defaults to [MethodChannelUrlLauncher].
  static KdScannerPlatform get instance => _instance;

  /// Platform-specific plugins should set this with their own platform-specific
  /// class that extends [KdScannerPlatform] when they register themselves.
  static set instance(KdScannerPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String> get platformVersion => throw UnimplementedError('platformVersion has not been implemented.');

  Future<String> scan() => throw UnimplementedError('scan has not been implemented.');
}
