#import "QCBaseView.h"
NS_ASSUME_NONNULL_BEGIN

typedef void(^WxCashTapActionCallBack)(void);

@interface QCHomeTopXJView : QCBaseView

@property (nonatomic, copy) WxCashTapActionCallBack tapActionCallBack;

- (void)updateView;

@end

NS_ASSUME_NONNULL_END
