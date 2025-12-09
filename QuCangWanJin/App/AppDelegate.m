#import "AppDelegate.h"
#import <AppTrackingTransparency/AppTrackingTransparency.h>
#import <AdSupport/AdSupport.h>
#import "AppDelegate+WX.h"
#import <IQKeyboardManager/IQKeyboardManager.h>
#import "QCLauncherController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [MMKV initializeMMKV:nil];
    
    [BDASignalManager enableDelayUpload];

    [BDASignalManager didFinishLaunchingWithOptions:launchOptions connectOptions:nil];
    
    [[IQKeyboardManager sharedManager] setEnable:YES];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    QCLauncherController *launcherVc = [[QCLauncherController alloc] init];
    self.window.rootViewController = launcherVc;
    [self.window makeKeyAndVisible];
    
    
    [self registerWechat];
    
    return YES;
}

- (void)registerUmeng {
    [UMConfigure initWithAppkey:k_UMENG_APP_KEY channel:nil];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    if (@available(iOS 14, *)) {
        [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
            if (status == ATTrackingManagerAuthorizationStatusAuthorized) {
                NSString *idfa = [ASIdentifierManager sharedManager].advertisingIdentifier.UUIDString;
//                [XKDAdManager sharedInstance].deviceIDFA = idfa;
            }
        }];
    }else {
        NSString *idfa = [ASIdentifierManager sharedManager].advertisingIdentifier.UUIDString;

    }
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options {
    if ([MobClick handleUrl:url]) {
        return YES;
    }
    return [self wechatHandleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray<id<UIUserActivityRestoring>> * _Nullable))restorationHandler {
    return [self wechatHandleOpenUniversalLinkUserActivity:userActivity];
}



@end
