
#import "AppDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface AppDelegate (WX)<WXApiDelegate>

- (void)registerWechat;

- (BOOL)wechatHandleOpenURL:(NSURL *)url;

- (BOOL)wechatHandleOpenUniversalLinkUserActivity:(NSUserActivity *)userActivity;

@end

NS_ASSUME_NONNULL_END
