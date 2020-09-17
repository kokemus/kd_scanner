import 'dart:async';
import 'dart:html';
import 'package:js/js_util.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:kd_scanner/js/barcode_scanner.dart';
import 'package:kd_scanner/kd_scanner_platform_interface.dart';

class KdScannerPlugin extends KdScannerPlatform {

  BarcodeScanner _barcodeScanner;

  static void registerWith(Registrar registrar) async {
    await loadScript('assets/packages/kd_scanner/js/barcode_scanner.js');
    KdScannerPlatform.instance = KdScannerPlugin();    
  }

  static Future loadScript(String url) async {
    Completer c = new Completer();
    final script = document.createElement('script');
    script.setAttribute('type', 'text/javascript');
    document.querySelector('head').append(script);
    script.setAttribute('src', url);
    script.addEventListener('load', (event) => c.complete());
    return c.future;
  }

  KdScannerPlugin() {
    _barcodeScanner = BarcodeScanner();
  }

  @override
  Future<String> get platformVersion => Future.value(window.navigator.userAgent);

  @override
  Future<String> scan() {
    return promiseToFuture(_barcodeScanner.scan());
  }
}