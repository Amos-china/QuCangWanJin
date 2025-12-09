
#import "QCBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface QCRootModel : QCBaseModel

@property (nonatomic, assign) NSInteger code;
@property (nonatomic, copy) NSString *msg;
@property (nonatomic, copy) id data;

@end

NS_ASSUME_NONNULL_END
