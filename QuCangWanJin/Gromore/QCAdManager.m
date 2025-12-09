
#import "QCAdManager.h"
#import <AppTrackingTransparency/AppTrackingTransparency.h>
#import "QCADInterstitialSDK.h"
#import "QCSplashAdSDK.h"
#import "QCBannerAdSDK.h"
#import "QCSocketService.h"
#import <AdSupport/AdSupport.h>
#import "AQService+AD.h"
#import "AQService+Common.h"

static NSString *const k_mmkv_ad_start_config = @"k_mmkv_ad_start_config";

@interface QCAdManager ()

@property (nonatomic, strong) QCADInterstitialSDK *switchAdSDK;
@property (nonatomic, strong) QCADInterstitialSDK *interstitialSDK;
@property (nonatomic, strong) QCRewardedADSDK *rewardedAdSDK;
@property (nonatomic, strong) QCSplashAdSDK *splashAdSDK;
@property (nonatomic, strong) QCBannerAdSDK *bannerAdSDK;
@property (nonatomic, strong) QCNativeADSDK *nativeAdSDK;

@property (nonatomic, assign) BOOL isInitAdSDK;

@end

@implementation QCAdManager

+ (instancetype)sharedInstance {
    static QCAdManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[super allocWithZone:NULL] init];
        instance.deviceIDFA = @"00000000-0000-0000-0000-000000000000";
    });
    return instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [self sharedInstance];
}

// 重写方法【必不可少】
- (id)copyWithZone:(nullable NSZone *)zone{
    return self;
}

- (QCSplashAdSDK *)splashAdSDK {
    if (!_splashAdSDK) {
        _splashAdSDK = [[QCSplashAdSDK alloc] init];
        _splashAdSDK.config = [self getSplashExtraModel];
    }
    return _splashAdSDK;
}

- (QCADInterstitialSDK *)switchAdSDK {
    if (!_switchAdSDK) {
        _switchAdSDK = [[QCADInterstitialSDK alloc] init];
        _switchAdSDK.config = [self getswitchExtraModel];
    }
    return _switchAdSDK;
}

- (QCRewardedADSDK *)rewardedAdSDK {
    if (!_rewardedAdSDK) {
        _rewardedAdSDK = [[QCRewardedADSDK alloc] init];
        _rewardedAdSDK.config = [self getRewardVideoExtraModel];
    }
    return _rewardedAdSDK;
}

- (QCADInterstitialSDK *)interstitialSDK {
    if (!_interstitialSDK) {
        _interstitialSDK = [[QCADInterstitialSDK alloc] init];
        _interstitialSDK.config = [self getInterstitialExtraModel];
    }
    return _interstitialSDK;
}

- (QCBannerAdSDK *)bannerAdSDK {
    if (!_bannerAdSDK) {
        _bannerAdSDK = [[QCBannerAdSDK alloc] init];
        _bannerAdSDK.config = [self getBannerExtraModel];
    }
    return _bannerAdSDK;
}

- (QCNativeADSDK *)nativeAdSDK {
    if (!_nativeAdSDK) {
        _nativeAdSDK = [[QCNativeADSDK alloc] init];
        _nativeAdSDK.config = [self getNativeExtraModel];
    }
    return _nativeAdSDK;
}
    
- (void)requestHomeIndex:(void(^)(QCCommedHomeIndexModel *indexModel))success
                   error:(QCHTTPRequestResponseErrorBlock)error {
    __weak typeof(self) weakSelf = self;
    [QCService getCommedHomeIndexSuccess:^(id  _Nonnull data) {
        QCCommedHomeIndexModel *homeIndexModel = [QCCommedHomeIndexModel modelWithkeyValues:data];
        weakSelf.commedHomeIndexModel = homeIndexModel;
        success(homeIndexModel);
    } error:error];
}

- (void)commonVideoFinishUpdTime:(NSString *)logId ecpmInfo:(QCAdEcpmInfoModel *)ecpmInfo {
    [QCService commonVideoFinishUpdTime:logId ecpmInfo:ecpmInfo success:^(id  _Nonnull data) {
        NSLog(@"%@",data);
    } error:^(NSInteger code, NSString * _Nonnull msg) {
        NSLog(@"%@",msg);
    }];
}

- (void)loadAppAdConfigWithSuccess:(void(^)(void))success error:(void(^)(NSString *msg))error {
    if (@available(iOS 14, *)) {
        __weak typeof(self) weakSelf = self;
        [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
            if (status == ATTrackingManagerAuthorizationStatusAuthorized) {
                NSString *idfa = [ASIdentifierManager sharedManager].advertisingIdentifier.UUIDString;
                weakSelf.deviceIDFA = idfa;
                [BDASignalManager enableIdfa:YES];
            }
            [weakSelf requstAdConfigSuccess:success error:error];
        }];
    }else {
        NSString *idfa = [ASIdentifierManager sharedManager].advertisingIdentifier.UUIDString;
        self.deviceIDFA = idfa;
        [BDASignalManager enableIdfa:YES];
        [self requstAdConfigSuccess:success error:error];
    }
}

- (void)requstAdConfigSuccess:(void(^)(void))success error:(void(^)(NSString *msg))error {
    __weak typeof(self) weakSelf = self;
    [QCService getAdConfigSuccess:^(id  _Nonnull data) {
        weakSelf.appAdConfigModel = [QCGetAdConfigModel modelWithkeyValues:data];
        NSString *appAdConfigJson = [weakSelf.appAdConfigModel toJSONString];
        [[MMKV defaultMMKV] setString:appAdConfigJson forKey:k_mmkv_ad_start_config];
        
        weakSelf.switchAdSDK.startAdConfig = weakSelf.appAdConfigModel.qhcp_config;
        weakSelf.interstitialSDK.startAdConfig = weakSelf.appAdConfigModel.qhcp_config;
        [[QCSocketService sharedInstance] bindPort:weakSelf.appAdConfigModel.ad_report];
        //这么判断一下是为了防止多次初始化
        if (weakSelf.isInitAdSDK) {
            success();
        }else {
            [weakSelf registerGroMoreSuccess:success];
        }
    } error:^(NSInteger code, NSString * _Nonnull msg) {
        error(msg);
    }];
}

- (void)registerGroMoreSuccess:(void(^)(void))successBlock {
    BUAdSDKConfiguration *configuration = [BUAdSDKConfiguration configuration];
    configuration.appID = self.appAdConfigModel.ad_media_id.gm_media_id;
#if DEBUG
    configuration.debugLog = @(1);
#endif
    configuration.useMediation = YES;
    // 不限制个性化广告（聚合维度功能）
    configuration.mediation.limitPersonalAds = @(0);
    // 不限制程序化广告（聚合维度功能）
    configuration.mediation.limitProgrammaticAds = @(0);
    // 未成年配置
    configuration.ageGroup = BUAdSDKAgeGroupAdult;
    // 主题模式
    configuration.themeStatus = @(BUAdSDKThemeStatus_Normal);
    // 混音设置
    configuration.appLogoImage = [UIImage imageNamed:@"AppIcon"];
    configuration.allowModifyAudioSessionSetting = YES;
    //设置这个可以让后台音乐跟广告声音共存
    configuration.audioSessionSetType = BUAudioSessionSettingType_Mix;
    
    configuration.customIdfa = self.deviceIDFA;

    // 初始化
    __weak typeof(self) weakSelf = self;
    [BUAdSDKManager startWithAsyncCompletionHandler:^(BOOL success, NSError *error) {
        if (success) {
            weakSelf.isInitAdSDK = YES;
            dispatch_async(dispatch_get_main_queue(), ^{
                successBlock();
            });
        }
    }];
}

- (void)loadAllAD {
    [self loadSplashAd];
    [self loadSwitchAd];
    [self loadRewardVideoAd];
    [self loadInterstitialAd];
    [self loadBannerAd];
}

- (void)loadRewardVideoAd {
    if (!self.appAdConfigModel) {return;}
    if (self.appAdConfigModel.ad_fj.sp_fj) {return;}
    [self.rewardedAdSDK loadAd];
}

- (BOOL)showRewardVideoAdWithController:(UIViewController *)controller completionHandler:(nonnull CloseAdCompletionHandler)completionHandler {
    if (!self.appAdConfigModel) {return NO;}
    if (self.appAdConfigModel.ad_fj.sp_fj) {return NO;}
    return [self.rewardedAdSDK showAdWithInController:controller completionHander:completionHandler];
}

- (BOOL)showRewardAdWithController:(UIViewController *)controller
                  completionHander:(CloseAdCompletionHandler)completionHander
                     clickAdHander:(ClickAdCompletionHandler)clickAdHander {
    if (!self.appAdConfigModel) {return NO;}
    if (self.appAdConfigModel.ad_fj.sp_fj) {return NO;}
    return [self.rewardedAdSDK showAdWithController:controller completionHander:completionHander clickAdHander:clickAdHander];
}

- (void)loadInterstitialAd {
    if (!self.appAdConfigModel) {return;}
    if (self.appAdConfigModel.ad_fj.qpsp_fj) {return;}
    [self.interstitialSDK loadAd];
}

- (BOOL)showInterstitialAdController:(UIViewController *)controller completionHandler:(nonnull CloseAdCompletionHandler)completionHandler {
    if (!self.appAdConfigModel) {return NO;}
    if (self.appAdConfigModel.ad_fj.qpsp_fj) {return NO;}
    return [self.interstitialSDK showAdWithInController:controller completionHander:completionHandler];
}

- (void)loadSwitchAd {
    if (!self.appAdConfigModel) {return;}
    if (self.appAdConfigModel.ad_fj.cp_fj) {return;}
    [self.switchAdSDK loadAd];
}

- (BOOL)showSwitcAdController:(UIViewController *)controller completionHandler:(CloseAdCompletionHandler)completionHandler {
    if (!self.appAdConfigModel) {return NO;}
    if (self.appAdConfigModel.ad_fj.cp_fj) {return NO;}
    return [self.switchAdSDK showAdWithInController:controller completionHander:completionHandler];
}

- (void)loadSplashAd {
    if (!self.appAdConfigModel) {return;}
    if (self.appAdConfigModel.ad_fj.kp_fj) {return;}
    [self.splashAdSDK loadAd];
}

- (BOOL)showSplashAdCompletionHandler:(CloseAdCompletionHandler)completionHandler {
    if (!self.appAdConfigModel) {return NO;}
    if (self.appAdConfigModel.ad_fj.kp_fj) {return NO;}
    return [self.splashAdSDK showSplashAdWithCompletionHander:completionHandler];
}

- (void)loadBannerAd {
    if (!self.appAdConfigModel) {return;}
    if (self.appAdConfigModel.ad_fj.hf_fj) {return;}
    [self.bannerAdSDK loadAd];
}

- (BOOL)showBannerAdWithSuperView:(UIView *)superView controller:(UIViewController *)controller {
    if (!self.appAdConfigModel) {return NO;}
    if (self.appAdConfigModel.ad_fj.hf_fj) {return NO;}
    return [self.bannerAdSDK showBannerAdWithSuperView:superView controller:controller];
}


- (void)loadNativeAd {
    if (!self.appAdConfigModel) {return;}
    if (self.appAdConfigModel.ad_fj.xxl_fj) {return;}
    [self.nativeAdSDK loadAd];
}

- (BUMCanvasView *)getNativeADViewWithController:(UIViewController *)controller {
    if (!self.appAdConfigModel) {return nil;}
    if (self.appAdConfigModel.ad_fj.xxl_fj) {return nil;}
    return [self.nativeAdSDK getNativeADViewWithController:controller];
}

- (QCAdInfoConfig *)getBannerExtraModel {
    return [self getAdExtraModelWithPosition:@"common_bottom_ad"];
}

- (QCAdInfoConfig *)getSplashExtraModel {
    return [self getAdExtraModelWithPosition:@"spa_ad"];
}

- (QCAdInfoConfig *)getswitchExtraModel {
    return [self getAdExtraModelWithPosition:@"switch_ad"];
}

- (QCAdInfoConfig *)getInterstitialExtraModel {
    return [self getAdExtraModelWithPosition:@"close_full_video_ad"];
}

- (QCAdInfoConfig *)getRewardVideoExtraModel {
    return [self getAdExtraModelWithPosition:@"hb_video_ad"];
}

- (QCAdInfoConfig *)getNativeExtraModel {
    return [self getAdExtraModelWithPosition:@"reward_code_ad"];
}

- (QCAdInfoConfig *)getAdExtraModelWithPosition:(NSString *)position {
    for (QCAdInfoConfig *config in self.appAdConfigModel.gromore_ad_list) {
        if ([position isEqualToString:config.position]) {
            return config;
        }
    }
    return nil;
}

@end
