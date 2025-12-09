#import "QCBaseModel.h"
#import "QCWithrawalListModel.h"
NS_ASSUME_NONNULL_BEGIN
@class QCXJCashOutTxUserListModel;
@interface QCXJCashOutModel : QCBaseModel

@property (nonatomic, strong) QCUserInfoModel *user_info;
@property (nonatomic, copy) NSString *rule;
@property (nonatomic, strong) NSMutableArray<QCWithrawalListModel *> *withdrawal_list;
@property (nonatomic, strong) QCWithrawalListModel *withdrawal;
@property (nonatomic, copy) NSArray<QCXJCashOutTxUserListModel *> *tx_user_list;

@end


@interface QCXJCashOutTxUserListModel: QCBaseModel

@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *face;
@property (nonatomic, copy) NSString *money;

@end

NS_ASSUME_NONNULL_END
