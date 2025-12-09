#import <UIKit/UIKit.h>
#import "UIViewController+ShowAd.h"
NS_ASSUME_NONNULL_BEGIN

@interface QCBaseViewController : UIViewController

- (void)popViewController;
- (void)pushViewController:(UIViewController *)viewController;

- (void)showRewardAdAtCustomToast:(NSString *)toast
                            close:(CloseAdCompletionHandler)close
                            error:(QCHTTPRequestResponseErrorBlock)error;

- (void)updateAppUrl:(NSString *)downloadUrl;

- (LOTAnimationView *)createAnimationViewAt:(NSString *)name;
- (LOTAnimationView *)createWxAnimationView;
- (LOTAnimationView *)createHbAnimationView;

@end

NS_ASSUME_NONNULL_END
