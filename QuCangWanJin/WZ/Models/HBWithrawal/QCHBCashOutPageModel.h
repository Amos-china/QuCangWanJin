#import "QCBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@class QCKfConfigModel;
@interface QCHBCashOutPageModel : QCBaseModel

@property (nonatomic, assign) NSInteger gold_tx_lj_switch;
@property (nonatomic, assign) NSInteger cash_hb_num;
@property (nonatomic, copy) NSString *now_gold;
@property (nonatomic, copy) NSString *can_tx_gold_money;
@property (nonatomic, copy) NSString *gold_money;
@property (nonatomic, copy) NSString *now_hbq;
@property (nonatomic, copy) NSString *hbq_money;
@property (nonatomic, copy) NSString *rule;
@property (nonatomic, copy) NSString *min_tx_money;
@property (nonatomic, copy) NSString *exchange_rate;
@property (nonatomic, strong) QCKfConfigModel *kf_config;

@end

@interface QCKfConfigModel : QCBaseModel

@property (nonatomic, assign) NSInteger kf_status;
@property (nonatomic, copy) NSString *qq;
@property (nonatomic, copy) NSString *key;
@property (nonatomic, assign) NSInteger cash_out_stop;
@property (nonatomic, assign) NSInteger condition;
@property (nonatomic, assign) NSInteger has_cash_out_num;

@end

NS_ASSUME_NONNULL_END
