import 'dart:async';

import 'package:kd_scanner/kd_scanner_platform_interface.dart';

Future<String> get platformVersion async {
  return await KdScannerPlatform.instance.platformVersion;
}

Future<String> scan() async {
  return await KdScannerPlatform.instance.scan();
}