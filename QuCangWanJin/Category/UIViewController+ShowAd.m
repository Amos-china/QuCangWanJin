//
//  UIViewController+ShowAd.m
//  MelonTheater
//
//  Created by 陈志远 on 2024/1/18.
//

#import "UIViewController+ShowAd.h"
#import <objc/runtime.h>

@implementation UIViewController (ShowAd)

static void *CompletionBlockKey = &CompletionBlockKey;

- (CloseAdCompletionHandler)closeAdCompletionHanlder {
    return objc_getAssociatedObject(self, CompletionBlockKey);
}

- (void)setCloseAdCompletionHanlder:(CloseAdCompletionHandler)closeAdCompletionHanlder {
    objc_setAssociatedObject(self, CompletionBlockKey, closeAdCompletionHanlder, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)showSettlementSwitchAd {
    if([QCUserModel getUserModel].user_info.guide_page_num != 4) {return;}
    QCAppStartAdConfig *switchAdConfig = [QCAdManager sharedInstance].appAdConfigModel.qhyy_ad_config;
    if (switchAdConfig.ad_status) {
        __weak typeof(self) weakSelf = self;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(switchAdConfig.delayed * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf showSwitchAd];
        });
    }
}

- (void)changedControllerShowSwitchAd {
    QCAppStartAdConfig *adConfig = [QCAdManager sharedInstance].appAdConfigModel.qhcp_config;
    if (!adConfig.ad_status) {return;}
    
    NSInteger showCount = [QCAdManager sharedInstance].appAdConfigModel.changeControllerShowAdCount;
    showCount ++;
    [QCAdManager sharedInstance].appAdConfigModel.changeControllerShowAdCount = showCount;
    if (showCount == 1) {
        __weak typeof(self) weakSelf = self;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(adConfig.delayed * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf showSwitchAd];
        });
        return;
    }
    
    if (showCount % adConfig.page_qh_num) {
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(adConfig.delayed * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf showSwitchAd];
    });
}

- (BOOL)showInterstitialAd {
    QCAppAdBansModel *bansModel = [QCAdManager sharedInstance].appAdConfigModel.ad_fj;
    if (bansModel.qpsp_fj) {
        return NO;
    }
    
    UIViewController *controller = self.tabBarController ? self.tabBarController : self;
    BOOL show = [[QCAdManager sharedInstance] showInterstitialAdController:controller completionHandler:self.closeAdCompletionHanlder];
    
    return show;
}

- (BOOL)showSwitchAd {
    QCAppAdBansModel *bansModel = [QCAdManager sharedInstance].appAdConfigModel.ad_fj;
    if (bansModel.cp_fj) {
        return NO;
    }
    
    UIViewController *controller = self.tabBarController ? self.tabBarController : self;
    return [[QCAdManager sharedInstance] showSwitcAdController:controller completionHandler:self.closeAdCompletionHanlder];

}


@end
