#import "FlutterIcmpPingPlugin.h"
#if __has_include(<flutter_icmp_ping_platform/flutter_icmp_ping_platform-Swift.h>)
#import <flutter_icmp_ping_platform/flutter_icmp_ping_platform-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "flutter_icmp_ping_platform-Swift.h"
#endif

@implementation FlutterIcmpPingPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterIcmpPingPlugin registerWithRegistrar:registrar];
}
@end
