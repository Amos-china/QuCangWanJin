#import "QCBaseViewModel.h"

@implementation QCBaseViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.page = 1;
        self.num = 10;
    }
    return self;
}

- (void)uploadAdTimeWithLogId:(NSString *)logId ecpmInfo:(QCAdEcpmInfoModel *)ecpmInfo {
    [[QCAdManager sharedInstance] commonVideoFinishUpdTime:logId ecpmInfo:ecpmInfo];
}

@end
