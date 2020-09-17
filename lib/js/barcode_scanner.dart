@JS()
library barcode_scanner;

import 'package:js/js.dart';

@JS()
class BarcodeScanner {
  external BarcodeScanner();
  external Future<String> scan(); 
}