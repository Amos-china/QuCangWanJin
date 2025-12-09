//
//  AppDeviceInfo.h
//  MelonTheater
//
//  Created by 陈志远 on 2023/12/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AppDeviceInfo : NSObject

+ (NSString *)getUIDeviceUUID;

+ (int)SimCardNumInPhone;

+ (NSString *)getAppName;
+ (NSString *)getCurrentAppVersion;

+ (NSString *)getCurrentAppVersionCode;

+ (BOOL)isShowNewdUserGuide;
+ (void)showNewdUserEnd;


+ (void)setNewdApp;
+ (BOOL)isNewdApp;

+ (BOOL)getAppStatus;

+ (BOOL)isAppleLogin;
+ (void)setAppleLogin;
+ (void)appleLoginOut;

+ (BOOL)isShowQQAlert;
+ (void)setShowQQAlert;

@end

NS_ASSUME_NONNULL_END
