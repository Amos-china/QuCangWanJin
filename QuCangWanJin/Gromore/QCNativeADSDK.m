#import "QCNativeADSDK.h"


@interface QCNativeADSDK ()<BUMNativeAdsManagerDelegate,BUNativeAdDelegate,BUCustomEventProtocol>

@property (nonatomic, strong) BUNativeAdsManager *adManager;

@end

@implementation QCNativeADSDK

- (void)loadAd {
    if (self.isAdLoaded) {
        return;
    }
    
    if (self.adManager) {
        [self.adManager.mediation destory];
    }
    
    BUAdSlot *slot = [[BUAdSlot alloc] init];
    slot.ID = self.config.code;
    slot.adSize = CGSizeMake(KWidth, HEIGHT(200.f));
    slot.mediation.mutedIfCan = YES;
    BUSize *imgSize1 = [[BUSize alloc] init];
    imgSize1.width = KWidth;
    imgSize1.height = HEIGHT(200.f); // 按照实际情况设置宽高
    slot.imgSize = imgSize1;
        
    
    self.adManager = [[BUNativeAdsManager alloc] initWithSlot:slot];
    self.adManager.delegate = self;
    [self.adManager loadAdDataWithCount:1];
}

- (BUMCanvasView *)getNativeADViewWithController:(UIViewController *)controller {
    if (self.isAdLoaded) {
        self.adManager.mediation.rootViewController = controller;
        for (BUNativeAd *navtievAd in self.adManager.data) {
            navtievAd.rootViewController = controller;
            navtievAd.delegate = self;
            if (navtievAd.mediation.isExpressAd) {
               [navtievAd.mediation render];
            }
            
            if (navtievAd.mediation.canvasView) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    self.isAdLoaded = NO;
                    [self loadAd];
                });
                return navtievAd.mediation.canvasView;
            }
        }
    }
    return nil;
}

# pragma mark BUMNativeAdsManagerDelegate
// 广告加载成功
- (void)nativeAdsManagerSuccessToLoad:(BUNativeAdsManager *)adsManager nativeAds:(NSArray<BUNativeAd *> *_Nullable)nativeAdDataArray {
    self.isAdLoaded = YES;
}

// 广告加载失败
- (void)nativeAdsManager:(BUNativeAdsManager *)adsManager didFailWithError:(NSError *_Nullable)error {
    self.isAdLoaded = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self loadAd];
    });
}

/******** 信息流广告展示回调处理 *********/
#pragma mark BUMNativeAdDelegate

// 广告视图展示
- (void)nativeAdDidBecomeVisible:(BUNativeAd *)nativeAd {
//    [self didShowWithPlacementID:placementID extra:extra];
    BUMRitInfo *info = [nativeAd.mediation getShowEcpmInfo];
    [self didShowWith:info];
}

// 广告被点击
- (void)nativeAdDidClick:(BUNativeAd *)nativeAd withView:(UIView *)view {
//    [self didClickWithPlacementID:placementID extra:extra];
    BUMRitInfo *info = [nativeAd.mediation getShowEcpmInfo];
    [self didShowWith:info];
}

// 广告渲染成功，仅模板广告会回调
- (void)nativeAdExpressViewRenderSuccess:(BUNativeAd *)nativeAd {
    // 渲染后广告视图的尺寸可能调整，可以在此刷新UI
}

// 广告渲染失败
- (void)nativeAdExpressViewRenderFail:(BUNativeAd *)nativeAd error:(NSError *)error {
    
}

// 负反馈
- (void)nativeAd:(BUNativeAd *_Nullable)nativeAd dislikeWithReason:(NSArray<BUDislikeWords *> *_Nullable)filterWords {
    // 需手动移除视图
}

// 视频播放状态变更
- (void)nativeAdVideo:(BUNativeAd *)nativeAd stateDidChanged:(BUPlayerPlayState)playerState {
    
}

// 视频播放完成
- (void)nativeAdVideoDidPlayFinish:(BUNativeAd *_Nullable)nativeAd {
    
}

- (void)nativeAd:(BUNativeAd *)nativeAd adContainerViewDidRemoved:(UIView *)adContainerView {
    
}
@end
