#import <UIKit/UIKit.h>

typedef void(^WechatOnResp)(BaseResp *resp);

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, copy) WechatOnResp wechatOnResp;

- (void)registerUmeng;

@end

