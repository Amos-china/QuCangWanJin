#import "QCBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface QCUserInfoModel : QCBaseModel

@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *show_user_id;
@property (nonatomic, assign) NSInteger is_new_user;
@property (nonatomic, copy) NSString *invitation_code;
@property (nonatomic, copy) NSString *reg_time;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *face;
@property (nonatomic, assign) NSInteger new_user_gold;
@property (nonatomic, copy) NSString *now_gold;
@property (nonatomic, copy) NSString *gold_money;
@property (nonatomic, copy) NSString *now_hbq; //当前现金
@property (nonatomic, copy) NSString *hbq_money;//用户当前的现金对应的金额
@property (nonatomic, assign) NSInteger xjtx_need_stage_num;//再过几关全部提现
@property (nonatomic, assign) NSInteger now_txq;
@property (nonatomic, copy) NSString *txq_money;
@property (nonatomic, assign) NSInteger now_binge_watch_level;
@property (nonatomic, assign) NSInteger next_binge_watch_level;
@property (nonatomic, assign) NSInteger need_binge_num;
@property (nonatomic, assign) NSInteger bind_wechat;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, assign) NSInteger guide_page_num;
@property (nonatomic, assign) NSInteger now_stage_num;//当前游戏所处关卡数
@property (nonatomic, assign) NSInteger now_game_num;//当前游戏关卡所处的局数
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *token;
@property (nonatomic, copy) NSString *level;
@property (nonatomic, assign) NSInteger isGetFirstVideoHB;

@end

NS_ASSUME_NONNULL_END
