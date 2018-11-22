#import "AwareframeworkPedometerPlugin.h"
#import <awareframework_pedometer/awareframework_pedometer-Swift.h>

@implementation AwareframeworkPedometerPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftAwareframeworkPedometerPlugin registerWithRegistrar:registrar];
}
@end
