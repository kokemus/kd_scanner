import 'dart:async';

import 'package:flutter/services.dart';
import 'package:kd_scanner/kd_scanner_platform_interface.dart';

const MethodChannel _channel = MethodChannel('kd_scanner');

class MethodChannelKdScanner extends KdScannerPlatform {

  @override
  Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  @override
  Future<String> scan() async {
    final String code = await _channel.invokeMethod('scan');
    return code;
  }
}
