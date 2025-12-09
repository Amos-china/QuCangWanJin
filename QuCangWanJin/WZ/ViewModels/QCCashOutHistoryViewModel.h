#import "QCBaseViewModel.h"
#import "QCCashOutGetLogModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface QCCashOutHistoryViewModel : QCBaseViewModel

@property (nonatomic, strong) NSMutableArray<QCCashOutGetLogModel *> *logModels;

- (void)requestCashLog:(OnSuccess)success error:(QCHTTPRequestResponseErrorBlock)error;

@end

NS_ASSUME_NONNULL_END
