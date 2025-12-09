#import "QCADBaseSDK.h"
#import "QCSocketService.h"

@implementation QCADBaseSDK

- (void)loadAd {
    
}

- (void)resetAdTouchCount {
    self.touchCount = 0;
}

- (void)didShowWith:(BUMRitInfo *)ritInfo {
    [self sendMessageType:1 ritInfo:ritInfo];
}

- (void)didClickWith:(BUMRitInfo *)ritInfo {
    self.touchCount ++;
    
    if (self.touchCount > 30) {
        //封禁的逻辑
    }
    //上报逻辑
    [self sendMessageType:2 ritInfo:ritInfo];
}


- (void)sendMessageType:(NSInteger)type ritInfo:(BUMRitInfo *)ritInfo {
    NSString *userId = [QCUserModel getUserModel].user_info.user_id;
    NSString *appId = [QCService getApiVersion];
    QCAdEcpmInfoModel *ecpmInfo = [self getEcpmInfoWith:ritInfo];
    NSString *adTypeStr = SF(@"%@/%@",self.config.position,ecpmInfo.adType);
    NSString *adCode = SF(@"%@/%@/%@/1",self.config.code,ecpmInfo.plateCode,ecpmInfo.ecpm);
    NSString *actionType = @"show";
    if (type == 1) {
        actionType = @"show";
    }else if (type == 2) {
        actionType = @"click";
    }
    NSString *sendMessage = SF(@"%@,%@,%@,%@,%@",userId,appId,adTypeStr,adCode,actionType);
    [[QCSocketService sharedInstance] sendMessage:sendMessage type:type];
}

- (QCAdEcpmInfoModel *)getEcpmInfoWithExtra:(NSDictionary *)extra {
    QCAdEcpmInfoModel *infoModel = [QCAdEcpmInfoModel modelWithkeyValues:extra];
    infoModel.plateCode = SF(@"%ld",infoModel.network_placement_id);
    infoModel.adType = [QCAdEcpmInfoModel networkFirmId:infoModel.network_firm_id];
    infoModel.ecpm = SF(@"%.3f",infoModel.adsource_price * 100);
    return infoModel;
}

- (BOOL)showAdWithInController:(UIViewController *)controller completionHander:(CloseAdCompletionHandler)completionHander {
    self.closeAdCompletionHandler = completionHander;
    return NO;
}

- (BOOL)showSplashAdWithCompletionHander:(CloseAdCompletionHandler)completionHander {
    self.closeAdCompletionHandler = completionHander;
    return NO;
}

- (BOOL)showBannerAdWithSuperView:(UIView *)superView controller:(UIViewController *)controller {
    return NO;
}

//gromore
- (QCAdEcpmInfoModel *)getEcpmInfoWith:(BUMRitInfo *)ritInfo {
    QCAdEcpmInfoModel *ecpmInfo = [[QCAdEcpmInfoModel alloc] init];
    ecpmInfo.ecpm = ritInfo.ecpm == nil ? @"0" : ritInfo.ecpm;
    ecpmInfo.plateCode = ritInfo.slotID;
    ecpmInfo.adType = [QCAdEcpmInfoModel gromoreAdType:ritInfo.adnName];
    return ecpmInfo;
}



@end
