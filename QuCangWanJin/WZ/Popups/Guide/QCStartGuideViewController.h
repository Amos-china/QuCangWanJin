#import "QCBasePopupViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger,StartGuideType) {
    StartGuideTypeStart,
    StartGuideTypeNext
};

@interface QCStartGuideViewController : QCBasePopupViewController

@property (nonatomic, assign) StartGuideType guideType;

@end

NS_ASSUME_NONNULL_END
