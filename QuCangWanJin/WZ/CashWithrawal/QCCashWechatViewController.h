#import "QCAdBaseViewController.h"

typedef void(^WechatCashSuccessCallBack)(void);

NS_ASSUME_NONNULL_BEGIN

@interface QCCashWechatViewController : QCAdBaseViewController

@property (nonatomic, copy) WechatCashSuccessCallBack cashSuccessCallBack;

@end

NS_ASSUME_NONNULL_END
