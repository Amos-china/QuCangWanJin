//
//  XKDADInterstitialSDK.h
//  MelonTheater
//
//  Created by 陈志远 on 2024/1/17.
//

#import "QCADBaseSDK.h"

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, AQADInterstitialSDKType) {
    AQADInterstitialSDKTypesSwitch= 0,
    AQADInterstitialSDKTypeInterstitial
};

@interface QCADInterstitialSDK : QCADBaseSDK

@property (nonatomic, strong) QCAppStartAdConfig *startAdConfig;
@property (nonatomic, assign) BOOL isShowing;
@property (nonatomic, assign) AQADInterstitialSDKType adType;

@end

NS_ASSUME_NONNULL_END
