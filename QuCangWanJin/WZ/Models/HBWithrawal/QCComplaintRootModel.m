#import "QCComplaintRootModel.h"

@implementation QCComplaintRootModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{
        @"complaint_list": [QCComplaintItemModel class],
        @"feedback_list": [QCComplaintItemModel class]
    };
}

@end


@implementation QCComplaintItemModel



@end
