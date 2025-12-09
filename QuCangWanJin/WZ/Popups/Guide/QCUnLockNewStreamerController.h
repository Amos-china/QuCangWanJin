#import "QCBasePopupViewController.h"
#import "QCMusicIndexModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^ClooseAssistantCallBack)(NSString *);

@interface QCUnLockNewStreamerController : QCBasePopupViewController

@property (nonatomic, strong) QCGameIndexAssisTantPopModel *popModel;
@property (nonatomic, copy) ClooseAssistantCallBack callBack;
@property (nonatomic, assign) BOOL isNewUser;

@end

NS_ASSUME_NONNULL_END
