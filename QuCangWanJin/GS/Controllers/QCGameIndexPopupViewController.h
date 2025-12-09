#import "QCBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, GameIndexPopupType) {
    GameIndexPopupTypeSuccess,
    GameIndexPopupTypeError
};

typedef void(^GameIndexPopupButtonActionCallBack)(NSInteger index);

@interface QCGameIndexPopupViewController : QCBaseViewController

@property (nonatomic, assign) GameIndexPopupType popupType;
@property (nonatomic, copy) GameIndexPopupButtonActionCallBack actionCallBack;

@end

NS_ASSUME_NONNULL_END
