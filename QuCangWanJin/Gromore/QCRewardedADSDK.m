#import "QCRewardedADSDK.h"

@interface QCRewardedADSDK ()<BUMNativeExpressRewardedVideoAdDelegate>

@property (nonatomic, strong) BUNativeExpressRewardedVideoAd *rewardedVideoAd;
@property (nonatomic, assign) BOOL isGiveReward;
@property (nonatomic, copy) ClickAdCompletionHandler clickAdCompletion;
@property (nonatomic, strong) dispatch_source_t timer;
@property (nonatomic, assign) NSInteger lookTime;
@property (nonatomic, assign) NSInteger ad_error1;//广告播放时长一致 达到3次
@property (nonatomic, assign) NSInteger ad_error2;//广告播放时长小于15秒 记录时间
@property (nonatomic, assign) NSInteger lastTime; // 记录上一次的广告时长
@property (nonatomic, assign) BOOL isLogTime;

@property (nonatomic, copy) NSString *logStartTime;
@property (nonatomic, copy) NSString *logEndTime;

@end

@implementation QCRewardedADSDK


- (void)loadAd {
    if (self.isAdLoaded || self.isAdShowing) {
        return;
    }
    
    // 奖励发放设置
    BURewardedVideoModel *rewardedVideoModel = [[BURewardedVideoModel alloc] init];
    QCUserModel *userModel = [QCUserModel getUserModel];
    if (userModel) {
        rewardedVideoModel.userId = userModel.user_info.user_id;
    }
    BUAdSlot *slot = [[BUAdSlot alloc] init];
    slot.ID = self.config.code;
    slot.mediation.mutedIfCan = NO;
    BUNativeExpressRewardedVideoAd *rewardedVideoAd = [[BUNativeExpressRewardedVideoAd alloc] initWithSlot:slot rewardedVideoModel:rewardedVideoModel];
    rewardedVideoAd.delegate = self;
    
    [rewardedVideoAd.mediation addParam:@(0) withKey:@"show_direction"];
    self.rewardedVideoAd = rewardedVideoAd;
    [self.rewardedVideoAd loadAdData];
}

- (BOOL)showAdWithInController:(UIViewController *)controller completionHander:(CloseAdCompletionHandler)completionHander {
    self.closeAdCompletionHandler = completionHander;
    if (self.isAdLoaded) {
        self.isLogTime = YES;
        self.logStartTime = @"0";
        self.logEndTime = @"0";
        self.closeAdCompletionHandler = completionHander;
        [_rewardedVideoAd showAdFromRootViewController:controller];
    }
    return self.isAdLoaded;
}

- (BOOL)showAdWithController:(UIViewController *)controller
            completionHander:(CloseAdCompletionHandler)completionHander
               clickAdHander:(ClickAdCompletionHandler)clickAdHander {
    self.clickAdCompletion = clickAdHander;
    return [self showAdWithInController:controller completionHander:completionHander];
}



#pragma mark - BUMNativeExpressRewardedVideoAdDelegate
// 广告加载成功
- (void)nativeExpressRewardedVideoAdDidLoad:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd {
    // 广告加载成功之后，可以调用展示方法，按照实际需要调整代码位置
    self.isAdLoaded = YES;
}

// 广告加载失败
- (void)nativeExpressRewardedVideoAd:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd didFailWithError:(NSError *_Nullable)error {
    self.isAdLoaded = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self loadAd];
    });
}

// 广告素材加载完成
- (void)nativeExpressRewardedVideoAdDidDownLoadVideo:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd {

}

// 广告展示失败
- (void)nativeExpressRewardedVideoAdDidShowFailed:(BUNativeExpressRewardedVideoAd *_Nonnull)rewardedVideoAd error:(NSError *_Nonnull)error {
    self.isAdShowing = NO;
    [self loadAd];
}

// 广告已经展示
- (void)nativeExpressRewardedVideoAdDidVisible:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd {
    self.isAdShowing = YES;
    self.isGiveReward = NO;
    BUMRitInfo *info = [rewardedVideoAd.mediation getShowEcpmInfo];
    [self didShowWith:info];
    
    [self startTimer];
}

// 广告已经关闭
- (void)nativeExpressRewardedVideoAdDidClose:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd {
    self.isAdShowing = NO;
    self.isAdLoaded = NO;
    
    [self resetAdTouchCount];
    
    [self endTimer];
    
    self.logEndTime = [NSDate getCurrentTimestamp];
    
    if (self.isLogTime) {
        if (self.lookTime == self.lastTime) {
            self.ad_error1 ++;
        }else {
            self.ad_error1 = 0;
        }
        
        if (self.lookTime < 15) {
            self.ad_error2 ++;
        }else {
            self.ad_error2 = 0;
        }
    }
   
    BUMRitInfo *ritInfo = [rewardedVideoAd.mediation getShowEcpmInfo];
    QCAdEcpmInfoModel *infoModel = [self getEcpmInfoWith:ritInfo];
    infoModel.isGiveReward = self.isGiveReward;
    infoModel.startTime = self.logStartTime;
    infoModel.endTime = self.logEndTime;
    if (self.ad_error1 >= 3) {
        infoModel.is_error_1 = YES;
    }
    
    if (self.ad_error2 >= 3) {
        infoModel.is_error_2 = YES;
    }
    
    if (self.closeAdCompletionHandler) {
        self.closeAdCompletionHandler(infoModel);
    }
    //这里预加载下一个
    [self loadAd];
}

// 广告被点击
- (void)nativeExpressRewardedVideoAdDidClick:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd {
    BUMRitInfo *info = [rewardedVideoAd.mediation getShowEcpmInfo];
    [self didClickWith:info];
    
    !self.clickAdCompletion ? :self.clickAdCompletion();
}

// 广告被点击跳过
- (void)nativeExpressRewardedVideoAdDidClickSkip:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd {

}

// 广告视频播放完成
- (void)nativeExpressRewardedVideoAdDidPlayFinish:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd didFailWithError:(NSError *_Nullable)error {
    
}

// 广告奖励下发
- (void)nativeExpressRewardedVideoAdServerRewardDidSucceed:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd verify:(BOOL)verify {
    self.isGiveReward = verify;
}

// 广告奖励下发失败
- (void)nativeExpressRewardedVideoAdServerRewardDidFail:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd error:(NSError *_Nullable)error {
    self.isGiveReward = NO;
}

- (void)nativeExpressRewardedVideoAdDidCloseOtherController:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd interactionType:(BUInteractionType)interactionType {
    
}

- (void)startTimer {
    // 创建GCD定时器
    [self endTimer];
    
    self.logStartTime = [NSDate getCurrentTimestamp];
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    // 设置定时器 (1秒触发一次)
    dispatch_source_set_timer(self.timer, dispatch_time(DISPATCH_TIME_NOW, 0), 1 * NSEC_PER_SEC, 0);
    
    // 设置定时器回调
    __weak typeof(self) weakSelf = self;
    dispatch_source_set_event_handler(self.timer, ^{
        weakSelf.lookTime ++;
    });
    
    // 启动定时器
    dispatch_resume(self.timer);
}

- (void)endTimer {
    self.lookTime = 0;
    
    if (self.timer) {
        dispatch_source_cancel(self.timer);
        self.timer = nil;
    }
}

@end
