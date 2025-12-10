//
//  QCFeedBackRootModel.m
//  QuCangWanJin
//
//  Created by 陈志远 on 2025/12/10.
//

#import "QCFeedBackRootModel.h"

@implementation QCFeedBackRootModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{
        @"complaint_list": [QCFeedBackItemModel class],
        @"feedback_list": [QCFeedBackItemModel class]
    };
}

@end
