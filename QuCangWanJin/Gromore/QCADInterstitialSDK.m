#import "QCADInterstitialSDK.h"

@interface QCADInterstitialSDK() <BUMNativeExpressFullscreenVideoAdDelegate>

@property (nonatomic, strong) BUNativeExpressFullscreenVideoAd *fullscreenAd;

@end

@implementation QCADInterstitialSDK


- (void)loadAd {
    if (self.isAdLoaded || self.isAdShowing) {
        return;
    }
    BUAdSlot *slot = [[BUAdSlot alloc] init];
    slot.ID = self.config.code;
    slot.mediation.mutedIfCan = YES;
    BUNativeExpressFullscreenVideoAd *fullscreenAd = [[BUNativeExpressFullscreenVideoAd alloc] initWithSlot:slot];
    [fullscreenAd.mediation addParam:@(0) withKey:@"show_direction"];
    fullscreenAd.delegate = self;
    self.fullscreenAd = fullscreenAd;
    [self.fullscreenAd loadAdData];
}

- (BOOL)showAdWithInController:(UIViewController *)controller completionHander:(CloseAdCompletionHandler)completionHander {
    if (!self.isAdLoaded || self.isAdShowing) {
        return NO;
    }
    self.closeAdCompletionHandler = completionHander;
    [self.fullscreenAd showAdFromRootViewController:controller];
    return YES;
}


/******** 插全屏广告回调处理 *********/
#pragma mark - BUMNativeExpressFullscreenVideoAdDelegate
// 广告加载成功
- (void)nativeExpressFullscreenVideoAdDidLoad:(BUNativeExpressFullscreenVideoAd *)fullscreenVideoAd {
    // 广告加载成功之后，可以调用展示方法，按照实际需要调整代码位置
    self.isAdLoaded = YES;
}

// 广告加载失败
- (void)nativeExpressFullscreenVideoAd:(BUNativeExpressFullscreenVideoAd *)fullscreenVideoAd didFailWithError:(NSError *_Nullable)error {
    self.isAdLoaded = NO;
    // 加载失败后尝试重新加载
   dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
       [self loadAd];
   });
}

// 广告素材加载完成
- (void)nativeExpressFullscreenVideoAdDidDownLoadVideo:(BUNativeExpressFullscreenVideoAd *)fullscreenVideoAd {
    
}

// 广告即将展示
- (void)nativeExpressFullscreenVideoAdWillVisible:(BUNativeExpressFullscreenVideoAd *)fullscreenVideoAd {
    
}

// 广告已经展示
- (void)nativeExpressFullscreenVideoAdDidVisible:(BUNativeExpressFullscreenVideoAd *)fullscreenVideoAd {
    /*
    //  (注意: getShowEcpmInfo 需要在当前广告展示之后调用, 展示之前调用该方法会返回 nil)
    BUMRitInfo *info = [fullscreenVideoAd.mediation getShowEcpmInfo];
    NSLog(@"ecpm:%@", info.ecpm);
    NSLog(@"platform:%@", info.adnName);
    NSLog(@"ritID:%@", info.slotID);
    NSLog(@"requestID:%@", info.requestID ?: @"None");
    */
    self.isAdShowing = YES;
    
    BUMRitInfo *info = [fullscreenVideoAd.mediation getShowEcpmInfo];
    [self didShowWith:info];
}

// 广告被点击
- (void)nativeExpressFullscreenVideoAdDidClick:(BUNativeExpressFullscreenVideoAd *)fullscreenVideoAd {
    BUMRitInfo *info = [fullscreenVideoAd.mediation getShowEcpmInfo];
    [self didShowWith:info];
}

// 广告被点击跳过
- (void)nativeExpressFullscreenVideoAdDidClickSkip:(BUNativeExpressFullscreenVideoAd *)fullscreenVideoAd {

}

// 广告即将关闭
- (void)nativeExpressFullscreenVideoAdWillClose:(BUNativeExpressFullscreenVideoAd *)fullscreenVideoAd {
    
}

// 广告已经关闭
- (void)nativeExpressFullscreenVideoAdDidClose:(BUNativeExpressFullscreenVideoAd *)fullscreenVideoAd {
    self.isAdShowing = NO;
    self.isAdLoaded = NO;
    [self resetAdTouchCount];
    
    BUMRitInfo *ritInfo = [fullscreenVideoAd.mediation getShowEcpmInfo];
    QCAdEcpmInfoModel *infoModel = [self getEcpmInfoWith:ritInfo];
    !self.closeAdCompletionHandler ? :self.closeAdCompletionHandler(infoModel);
    
    [self loadAd];
}

// 广告视频播放完成
- (void)nativeExpressFullscreenVideoAdDidPlayFinish:(BUNativeExpressFullscreenVideoAd *)fullscreenVideoAd didFailWithError:(NSError *_Nullable)error {
    
}

// 广告展示失败
- (void)nativeExpressFullscreenVideoAdDidShowFailed:(BUNativeExpressFullscreenVideoAd *_Nonnull)fullscreenVideoAd error:(NSError *_Nonnull)error {
    self.isAdShowing = NO;
    [self loadAd];
}

// 即将弹出广告详情页回调
- (void)nativeExpressFullscreenVideoAdWillPresentFullScreenModal:(BUNativeExpressFullscreenVideoAd *_Nonnull)fullscreenVideoAd {

}

// 奖励验证回调成功
- (void)nativeExpressFullscreenVideoAdServerRewardDidSucceed:(BUNativeExpressFullscreenVideoAd *)fullscreenVideoAd verify:(BOOL)verify {

}

// 奖励验证回调失败
- (void)nativeExpressFullscreenVideoAdServerRewardDidFail:(BUNativeExpressFullscreenVideoAd *)fullscreenVideoAd error:(NSError *)error {
    
}

@end
