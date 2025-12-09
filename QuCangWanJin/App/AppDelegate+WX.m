
#import "AppDelegate+WX.h"

@implementation AppDelegate (WX)

- (void)registerWechat {
#if DEBUG
//    [WXApi startLogByLevel:WXLogLevelDetail logBlock:^(NSString * _Nonnull log) {
//        NSLog(@"%@",log);
//    }];
#endif
    
    [WXApi registerApp:WX_APP_ID universalLink:WX_APP_UNIVERSAL_LINK];
    
#if DEBUG
//    [WXApi checkUniversalLinkReady:^(WXULCheckStep step, WXCheckULStepResult* result) {
//        NSLog(@"%@, %u, %@, %@", @(step), result.success, result.errorInfo, result.suggestion);
//    }];
#endif
}

- (BOOL)wechatHandleOpenURL:(NSURL *)url {
    return [WXApi handleOpenURL:url delegate:self];
}

- (BOOL)wechatHandleOpenUniversalLinkUserActivity:(NSUserActivity *)userActivity {
    return [WXApi handleOpenUniversalLink:userActivity delegate:self];
}


#pragma mark - WXApiDelegat
- (void)onReq:(BaseReq *)req {

}

- (void)onResp:(BaseResp *)resp {
    if (self.wechatOnResp) {
        self.wechatOnResp(resp);
    }
}



@end
