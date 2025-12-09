#import "QCBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@class QCMusicModel,
QCMusicOptionModel,
QCGameIndexAssisTantPopModel,
QCGameCashConditionModel,
QCGameIndexGameProgressModel;

@interface QCMusicIndexModel : QCBaseModel

@property (nonatomic, strong) QCUserInfoModel *user_info;
@property (nonatomic, assign) NSInteger all_game_num;
@property (nonatomic, copy) NSString *xj_money;
@property (nonatomic, strong) QCMusicModel *question;
//@property (nonatomic, assign) NSInteger xjtx_need_stage_num;
@property (nonatomic, assign) NSInteger hb_can_tx;
@property (nonatomic, copy) NSString *assistant_pic;
@property (nonatomic, strong) QCGameIndexAssisTantPopModel *assistant_pop;
@property (nonatomic, assign) NSInteger xjtx_page;
@property (nonatomic, strong) QCGameCashConditionModel *xjtx_condition;
@property (nonatomic, strong) QCGameIndexGameProgressModel *game_progress;

@end

@interface QCMusicModel : QCBaseModel

@property (nonatomic, copy) NSString *music_id;
@property (nonatomic, assign) NSInteger sort;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *file;
@property (nonatomic, assign) NSInteger right_key;
@property (nonatomic, copy) NSArray<QCMusicOptionModel *> *option;

@end

@interface QCMusicOptionModel : QCBaseModel

@property (nonatomic, assign) NSInteger key;
@property (nonatomic, copy) NSString *title;

@end

@interface QCGameIndexAssisTantPopModel : QCBaseModel

@property (nonatomic, assign) NSInteger pop;
@property (nonatomic, copy) NSString *assisTant_id;
@property (nonatomic, copy) NSString *pic_thumb;
@property (nonatomic, copy) NSString *text;

@end

@interface QCGameCashConditionModel : QCBaseModel

@property (nonatomic, assign) NSInteger condition_type;
@property (nonatomic, copy) NSString *condition_value;
@property (nonatomic, assign) NSInteger tgs_condition;
@property (nonatomic, assign) NSInteger xjtx_page;
@end

@interface QCGameIndexGameProgressModel : QCBaseModel

@property (nonatomic, assign) NSInteger now_stage_num;
@property (nonatomic, assign) NSInteger now_game_num;
@property (nonatomic, assign) NSInteger config_game_num;
@property (nonatomic, assign) NSInteger now_act_num;
@property (nonatomic, assign) NSInteger config_act_num;
@property (nonatomic, assign) NSInteger now_rounds;
@property (nonatomic, assign) NSInteger all_rounds;

@end

NS_ASSUME_NONNULL_END
