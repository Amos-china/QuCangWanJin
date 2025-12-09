#import "QCAdBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^CashOutSuccess)(void);
typedef void(^DoCashHbCallBack)(void);

@interface QCHBWithdrawalController : QCAdBaseViewController

@property (nonatomic, copy) CashOutSuccess cashOutSuccess;
@property (nonatomic, copy) DoCashHbCallBack doCashHbCallBack;

@end

NS_ASSUME_NONNULL_END
