#import "QCBaseView.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^HbCashButtonCallBack)(void);

@interface QCHomeTopHBView : QCBaseView

@property (nonatomic, copy) HbCashButtonCallBack cashButtonCallBack;
- (void)updateView;

@end

NS_ASSUME_NONNULL_END
