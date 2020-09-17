#import "KdScannerPlugin.h"
#if __has_include(<kd_scanner/kd_scanner-Swift.h>)
#import <kd_scanner/kd_scanner-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "kd_scanner-Swift.h"
#endif

@implementation KdScannerPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftKdScannerPlugin registerWithRegistrar:registrar];
}
@end
