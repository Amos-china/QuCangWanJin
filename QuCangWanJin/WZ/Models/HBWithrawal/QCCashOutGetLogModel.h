#import "QCBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface QCCashOutGetLogModel : QCBaseModel

@property (nonatomic, copy) NSString *logId;
@property (nonatomic, copy) NSString *money;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, copy) NSString *data_time;

@end

NS_ASSUME_NONNULL_END
