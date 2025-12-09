#import "QCAdBaseViewController.h"
#import "QCXJWithrawalDetailViewController.h"
NS_ASSUME_NONNULL_BEGIN

typedef void(^WithrawalPopControllerCallBack)(void);

@interface QCXJWithdrawalViewController : QCAdBaseViewController

@property (nonatomic, copy) WithrawalPopControllerCallBack popCallBack;
@property (nonatomic, assign) BOOL isNewUser;

@end

NS_ASSUME_NONNULL_END
