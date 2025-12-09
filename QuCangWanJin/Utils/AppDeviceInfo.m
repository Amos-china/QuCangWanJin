//
//  AppDeviceInfo.m
//  MelonTheater
//
//  Created by 陈志远 on 2023/12/26.
//

#import "AppDeviceInfo.h"
#import "UuidObject.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>

static NSString *const k_mmkv_is_new_apple_app_version = @"k_mmkv_is_new_apple_app_version";
static NSString *const k_mmkv_is_apple_login = @"k_mmkv_is_apple_login";
static NSString *const k_mmkv_is_show_qq_alert = @"k_mmkv_is_show_qq_alert";

@implementation AppDeviceInfo

+ (NSString *)getUIDeviceUUID {
    return [UuidObject getUUID];
}

///方法二：获取手机中sim卡数量（推荐）
+ (int)SimCardNumInPhone {
     CTTelephonyNetworkInfo *networkInfo = [[CTTelephonyNetworkInfo alloc] init];
     if (@available(iOS 12.0, *)) {
          NSDictionary *ctDict = networkInfo.serviceSubscriberCellularProviders;
          if ([ctDict allKeys].count > 1) {
               NSArray *keys = [ctDict allKeys];
               CTCarrier *carrier1 = [ctDict objectForKey:[keys firstObject]];
               CTCarrier *carrier2 = [ctDict objectForKey:[keys lastObject]];
               if (carrier1.mobileCountryCode.length && carrier2.mobileCountryCode.length) {
                    return 2;
               }else if (!carrier1.mobileCountryCode.length && !carrier2.mobileCountryCode.length) {
                    return 0;
               }else {
                    return 1;
               }
          }else if ([ctDict allKeys].count == 1) {
               NSArray *keys = [ctDict allKeys];
               CTCarrier *carrier1 = [ctDict objectForKey:[keys firstObject]];
               if (carrier1.mobileCountryCode.length) {
                    return 1;
               }else {
                    return 0;
               }
          }else {
               return 0;
          }
     }else {
          CTCarrier *carrier = [networkInfo subscriberCellularProvider];
          NSString *carrier_name = carrier.mobileCountryCode;
          if (carrier_name.length) {
               return 1;
          }else {
               return 0;
          }
     }
}

+ (NSString *)getCurrentAppVersion {
    NSString *currentVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    return currentVersion;

}

+ (NSString *)getCurrentAppVersionCode {
    NSString *currentVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"AppVersionCode"];
    return currentVersion;
}

+ (NSString *)getAppName {
    NSString *name = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
    return name;
}

+ (BOOL)getAppStatus {
//    MTSettingVersionModel *versionModel = [self getAppVersionModel];
//    return versionModel.version_status;
    return YES;
}

@end
