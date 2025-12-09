#import "QCSplashAdSDK.h"

@interface QCSplashAdSDK ()<BUMSplashAdDelegate>

@property (nonatomic, strong) BUSplashAd *splashAd;

@end

@implementation QCSplashAdSDK

- (void)loadAd {
    BUAdSlot *slot = [[BUAdSlot alloc] init];
    slot.ID = self.config.code;
    slot.mediation.mutedIfCan = YES;
    self.splashAd = [[BUSplashAd alloc] initWithSlot:slot adSize:[UIScreen mainScreen].bounds.size];
    self.splashAd.delegate = self;
    [self.splashAd loadAdData];
}

- (BOOL)showSplashAdWithCompletionHander:(CloseAdCompletionHandler)completionHander {
    self.closeAdCompletionHandler = completionHander;
    if (self.isAdLoaded) {
        [self.splashAd showSplashViewInRootViewController:APPDELEGATE.window.rootViewController];
    }
    return self.isAdLoaded;
}

#pragma mark - BUMSplashAdDelegate
// 加载成功
- (void)splashAdLoadSuccess:(nonnull BUSplashAd *)splashAd {
    self.isAdLoaded = YES;
}

// 加载失败
- (void)splashAdLoadFail:(nonnull BUSplashAd *)splashAd error:(BUAdError * _Nullable)error {
    self.isAdLoaded = NO;
    [self.splashAd.mediation destoryAd];
}

// 广告即将展示
- (void)splashAdWillShow:(nonnull BUSplashAd *)splashAd {
    
}

- (void)splashAdDidShow:(BUSplashAd *)splashAd {
    BUMRitInfo *info = [splashAd.mediation getShowEcpmInfo];
    [self didShowWith:info];
}

// 广告被点击
- (void)splashAdDidClick:(nonnull BUSplashAd *)splashAd {
    BUMRitInfo *info = [splashAd.mediation getShowEcpmInfo];
    [self didShowWith:info];
}

// 广告被关闭
- (void)splashAdDidClose:(BUSplashAd *)splashAd closeType:(BUSplashAdCloseType)closeType {
    // 按照实际情况决定是否销毁广告对象
    [splashAd.mediation destoryAd];
    [self resetAdTouchCount];
    
    BUMRitInfo *ritInfo = [splashAd.mediation getShowEcpmInfo];
    QCAdEcpmInfoModel *infoModel = [self getEcpmInfoWith:ritInfo];
    [QCAdManager sharedInstance].splshAdEcpmInfo = infoModel;
    !self.closeAdCompletionHandler ? :self.closeAdCompletionHandler(infoModel);
}

- (void)splashAdRenderFail:(nonnull BUSplashAd *)splashAd error:(BUAdError * _Nullable)error {
    
}


- (void)splashAdRenderSuccess:(nonnull BUSplashAd *)splashAd {
    
}


- (void)splashAdViewControllerDidClose:(nonnull BUSplashAd *)splashAd {
    
}


- (void)splashDidCloseOtherController:(nonnull BUSplashAd *)splashAd interactionType:(BUInteractionType)interactionType {
    
}


- (void)splashVideoAdDidPlayFinish:(nonnull BUSplashAd *)splashAd didFailWithError:(NSError * _Nullable)error {
    
}


// 广告展示失败
- (void)splashAdDidShowFailed:(BUSplashAd *_Nonnull)splashAd error:(NSError *)error {
   
}


@end
