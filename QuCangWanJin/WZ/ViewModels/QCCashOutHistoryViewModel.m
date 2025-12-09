#import "QCCashOutHistoryViewModel.h"
#import "AQService+CashOutPage.h"

@implementation QCCashOutHistoryViewModel

- (instancetype)init {
    if (self = [super init]) {
        self.logModels = [NSMutableArray array];
    }
    return self;
}

- (void)requestCashLog:(OnSuccess)success error:(QCHTTPRequestResponseErrorBlock)error {
    __weak typeof(self) weakSelf = self;
    [QCService requestGetLog:0 success:^(id  _Nonnull data) {
        NSArray<QCCashOutGetLogModel *> *models = [QCCashOutGetLogModel mj_objectArrayWithKeyValuesArray:data];
        if (models.count > 0) {
            weakSelf.page ++;
        }
        [weakSelf.logModels addObjectsFromArray:models];
        success();
    } error:error];
}

@end
