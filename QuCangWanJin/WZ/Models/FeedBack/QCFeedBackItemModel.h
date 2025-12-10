//
//  QCFeedBackItemModel.h
//  QuCangWanJin
//
//  Created by 陈志远 on 2025/12/10.
//

#import "QCBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface QCFeedBackItemModel : QCBaseModel

@property (nonatomic, assign) NSInteger complaintId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) BOOL select;

@end

NS_ASSUME_NONNULL_END
