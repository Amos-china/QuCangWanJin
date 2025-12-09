#import "QCBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@class QCComplaintItemModel;

@interface QCComplaintRootModel : QCBaseModel

@property (nonatomic, copy) NSArray<QCComplaintItemModel *> *complaint_list;
@property (nonatomic, copy) NSArray<QCComplaintItemModel *> *feedback_list;

@end

@interface QCComplaintItemModel : QCBaseModel

@property (nonatomic, assign) NSInteger complaintId;
@property (nonatomic, copy) NSString *name;

@end

NS_ASSUME_NONNULL_END
