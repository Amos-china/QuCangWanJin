#import "QCAdBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^ClooseAssistantCallBack)(NSString *);

@interface QCAsisstionViewController : QCAdBaseViewController

@property (nonatomic, copy) ClooseAssistantCallBack clooseCallBack;

@end

NS_ASSUME_NONNULL_END
