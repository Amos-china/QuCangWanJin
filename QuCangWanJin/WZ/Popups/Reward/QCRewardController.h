#import "QCBasePopupViewController.h"
#import "QCGameHomeMusicViewModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger,AQRewardType) {
    AQRewardTypeNormal,
    AQRewardTypeNewUser
};

typedef void(^AutoDismissCallBack)(void);

@interface QCRewardController : QCBasePopupViewController

@property (nonatomic, assign) AQRewardType rewardType;
@property (nonatomic, strong) QCGameHomeMusicViewModel *indexViewModel;

@property (nonatomic, copy) AutoDismissCallBack autoDismiss;

@end

NS_ASSUME_NONNULL_END
