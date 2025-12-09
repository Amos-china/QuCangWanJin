#import "QCBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface QCCashWechatModel : QCBaseModel

@property (nonatomic, assign) NSInteger jl_type;
@property (nonatomic, assign) NSInteger is_direct;
@property (nonatomic, copy) NSString *jl_value;

@end

NS_ASSUME_NONNULL_END
