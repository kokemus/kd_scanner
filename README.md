# kd_scanner

A Flutter plugin to scan barcodes and QR codes.

*Easy to use and fast to integrate.*

## Usage

```
dependencies:
  kd_scanner:
    git:
      url: git://github.com/kokemus/kd_scanner.git

```

### Web

You must include [ZXing library](https://github.com/zxing-js/library) into your index.html file to be able to use this plugin.

```
<script src="https://unpkg.com/@zxing/library@latest"></script>
```

### iOS

You must include the NSCameraUsageDescription key in your app’s Info.plist file.

```
	<key>NSCameraUsageDescription</key>
	<string>"This app uses the camera for barcode scanning."</string>
```

See details [Requesting Authorization for Media Capture on iOS](https://developer.apple.com/documentation/avfoundation/cameras_and_media_capture/requesting_authorization_for_media_capture_on_ios).

### Example

``` dart
import 'package:kd_scanner/kd_scanner.dart';

try {
    String code = await scan();
    print(code);
} catch (e) {
    print(e);
}
```