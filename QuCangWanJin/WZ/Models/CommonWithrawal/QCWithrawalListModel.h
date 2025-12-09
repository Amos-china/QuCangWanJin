#import "QCBaseModel.h"
#import "QCMusicIndexModel.h"
@class QCWithrawalListTjModel;
NS_ASSUME_NONNULL_BEGIN

@interface QCWithrawalListModel : QCBaseModel

@property (nonatomic, copy) NSString *config_id;
@property (nonatomic, assign) NSInteger can_tx;
@property (nonatomic, assign) NSInteger game_num;
@property (nonatomic, assign) NSInteger level;
@property (nonatomic, assign) NSInteger tx_condition;
@property (nonatomic, assign) NSInteger line_up_num;
@property (nonatomic, assign) NSInteger tg_rate;
@property (nonatomic, copy) NSString *tx_money;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, assign) NSInteger condition_type;
@property (nonatomic, copy) NSString *min_tx_money;
@property (nonatomic, copy) NSString *need_money;

@property (nonatomic, assign) BOOL unLock;
@property (nonatomic, copy) NSString *taskTitle;
@property (nonatomic, copy) NSString *despText;
@property (nonatomic, copy) NSString *despColorHex;
@property (nonatomic, assign) BOOL canCash;

//@property (nonatomic, copy) NSString *money;
@property (nonatomic, assign) NSInteger is_direct;
@property (nonatomic, assign) NSInteger need_sm;
@property (nonatomic, strong) QCWithrawalListTjModel *tj;

@end


@interface QCWithrawalListTjModel : QCBaseModel

@property (nonatomic, assign) NSInteger tj_a_1;
@property (nonatomic, copy) NSString *tj_b_1;
@property (nonatomic, copy) NSString *tj_b_2;
@property (nonatomic, assign) NSInteger tj_c_1;
@property (nonatomic, assign) NSInteger tj_c_2;
@property (nonatomic, assign) NSInteger tj_c_3;
@property (nonatomic, assign) NSInteger tj_c_4;
@property (nonatomic, assign) NSInteger tj_d_1;
@property (nonatomic, assign) NSInteger tj_d_2;

@end

@interface QCWithrawalLuckyModel: QCBaseModel

@property (nonatomic, copy) NSString *get_money;
@property (nonatomic, strong) QCGameCashConditionModel *xjtx_condition;

@end

NS_ASSUME_NONNULL_END
