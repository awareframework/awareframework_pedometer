#import "AwareframeworkPedometerPlugin.h"
#if __has_include(<awareframework_pedometer/awareframework_pedometer-Swift.h>)
#import <awareframework_pedometer/awareframework_pedometer-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "awareframework_pedometer-Swift.h"
#endif

@implementation AwareframeworkPedometerPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftAwareframeworkPedometerPlugin registerWithRegistrar:registrar];
}
@end
