import 'dart:async';
import 'dart:html';
import 'package:barcode_scanner/barcode_scanner.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:kd_scanner/kd_scanner_platform_interface.dart';

class KdScannerPlugin extends KdScannerPlatform {
  late BarcodeScanner _barcodeScanner;

  static void registerWith(Registrar registrar) async {
    await BarcodeScannerFactory.loadScript();
    KdScannerPlatform.instance = KdScannerPlugin();
  }

  KdScannerPlugin() {
    _barcodeScanner = BarcodeScanner(BarcodeScannerOptions(
        formats: ['code_39', 'code_128', 'ean_13', 'qr_code']));
  }

  @override
  Future<String> get platformVersion =>
      Future.value(window.navigator.userAgent);

  @override
  Future<String> scan() {
    return _barcodeScanner.scan();
  }
}
