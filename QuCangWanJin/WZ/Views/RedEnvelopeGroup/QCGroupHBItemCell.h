#import "QCBaseTableViewCell.h"
#import "QCGroupMessageModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^HbButtonActionCallBack)(QCGroupMessageModel *);

@interface QCGroupHBItemCell : QCBaseTableViewCell

@property (nonatomic, strong) QCGroupMessageModel *msgModel;
@property (nonatomic, copy) HbButtonActionCallBack buttonActionCallBack;

@end

NS_ASSUME_NONNULL_END
