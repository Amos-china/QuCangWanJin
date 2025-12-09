#import "QCADBaseSDK.h"

NS_ASSUME_NONNULL_BEGIN

@interface QCRewardedADSDK : QCADBaseSDK

- (BOOL)showAdWithController:(UIViewController *)controller
            completionHander:(CloseAdCompletionHandler)completionHander
               clickAdHander:(ClickAdCompletionHandler)clickAdHander;


@end

NS_ASSUME_NONNULL_END

