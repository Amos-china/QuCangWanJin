
#import <Foundation/Foundation.h>
#import "QCAdExtraModel.h"
#import "QCGetAdConfigModel.h"
#import "QCAdEcpmInfoModel.h"
#import "QCRewardedADSDK.h"
#import "QCNativeADSDK.h"
#import "QCCommedHomeIndexModel.h"
#import "QCMusicIndexModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface QCAdManager : NSObject

@property (nonatomic, copy) NSString *deviceIDFA;

@property (nonatomic, strong) QCGetAdConfigModel *appAdConfigModel;

@property (nonatomic, strong) QCAdEcpmInfoModel *splshAdEcpmInfo;

@property (nonatomic, strong) QCCommedHomeIndexModel *commedHomeIndexModel;
@property (nonatomic, strong) QCGameCashConditionModel *conditionModel;

+ (instancetype)sharedInstance;

- (void)loadAppAdConfigWithSuccess:(void(^)(void))success error:(void(^)(NSString *msg))error;

- (void)loadAllAD;

- (void)loadRewardVideoAd;
- (BOOL)showRewardVideoAdWithController:(UIViewController *)controller completionHandler:(CloseAdCompletionHandler)completionHandler;
- (BOOL)showRewardAdWithController:(UIViewController *)controller
                  completionHander:(CloseAdCompletionHandler)completionHander
                     clickAdHander:(ClickAdCompletionHandler)clickAdHander;

- (void)loadInterstitialAd;
- (BOOL)showInterstitialAdController:(UIViewController *)controller completionHandler:(CloseAdCompletionHandler)completionHandler;

- (void)loadSwitchAd;
- (BOOL)showSwitcAdController:(UIViewController *)controller completionHandler:(CloseAdCompletionHandler)completionHandler;

- (void)loadSplashAd;
- (BOOL)showSplashAdCompletionHandler:(CloseAdCompletionHandler)completionHandler;

- (void)loadBannerAd;
- (BOOL)showBannerAdWithSuperView:(UIView *)superView controller:(UIViewController *)controller;

- (void)loadNativeAd;
- (BUMCanvasView *)getNativeADViewWithController:(UIViewController *)controller;


- (void)requestHomeIndex:(void(^)(QCCommedHomeIndexModel *indexModel))success
                   error:(QCHTTPRequestResponseErrorBlock)error;

- (void)commonVideoFinishUpdTime:(NSString *)logId ecpmInfo:(QCAdEcpmInfoModel *)ecpmInfo;

@end

NS_ASSUME_NONNULL_END
