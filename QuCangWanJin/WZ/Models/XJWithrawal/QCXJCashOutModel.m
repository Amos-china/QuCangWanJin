#import "QCXJCashOutModel.h"

@implementation QCXJCashOutModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{
        @"withdrawal_list": [QCWithrawalListModel class],
        @"tx_user_list": [QCXJCashOutTxUserListModel class]
    };
}

@end


@implementation QCXJCashOutTxUserListModel



@end
