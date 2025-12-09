#import "QCBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface QCUserSafe : QCBaseModel

//设备状态 1正常 0封禁 2注销
@property (nonatomic, assign) NSInteger status;

@end

NS_ASSUME_NONNULL_END
