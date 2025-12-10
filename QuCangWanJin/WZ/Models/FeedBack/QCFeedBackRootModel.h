//
//  QCFeedBackRootModel.h
//  QuCangWanJin
//
//  Created by 陈志远 on 2025/12/10.
//

#import "QCBaseModel.h"
#import "QCFeedBackItemModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface QCFeedBackRootModel : QCBaseModel

@property (nonatomic, copy) NSArray<QCFeedBackItemModel *> *complaint_list;
@property (nonatomic, copy) NSArray<QCFeedBackItemModel *> *feedback_list;

@end

NS_ASSUME_NONNULL_END
