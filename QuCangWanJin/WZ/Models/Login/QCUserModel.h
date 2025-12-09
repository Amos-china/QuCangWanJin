#import "QCBaseModel.h"
#import "QCUserInfoModel.h"
@class QCAccessibilityConfig;
@class QCSafConfig;
@class QCAutoHbConfig;

NS_ASSUME_NONNULL_BEGIN

@interface QCUserModel : QCBaseModel

//loginType 1:微信登录 2:apple登录
@property (nonatomic, assign) NSInteger loginType;
@property (nonatomic, copy) NSString *sbfj_msg;
@property (nonatomic, assign) NSInteger is_report;
@property (nonatomic, assign) NSInteger behavior_time;
@property (nonatomic, assign) NSInteger behavior_type;
@property (nonatomic, assign) NSInteger behavior_condition;
@property (nonatomic, assign) NSInteger exchange_rate1;
@property (nonatomic, copy) NSString *invite_agent_id;
@property (nonatomic, assign) NSInteger area_is_show;
@property (nonatomic, copy) NSArray<NSString *> *pb_package_name;

@property (nonatomic, strong) QCAccessibilityConfig *accessibility_config;
@property (nonatomic, strong) QCUserInfoModel *user_info;
@property (nonatomic, strong) QCSafConfig *saf_config;
@property (nonatomic, strong) QCAutoHbConfig *auto_hb_config;
@property (nonatomic, assign) NSInteger first_hb_get;
@property (nonatomic, assign) NSInteger invite_is_open;
@property (nonatomic, assign) NSInteger dl_is_open;
@property (nonatomic, copy) NSString *assistant_pic; //小助理图片
@property (nonatomic, assign) NSInteger auto_fb_jg;

+ (void)saveUserModel:(QCUserModel *)userModel;
+ (QCUserModel *)getUserModel;
+ (void)deleteUserModel;
+ (void)updateUserInfoModel:(QCUserInfoModel *)userInfoModel;

@end

@interface QCAccessibilityConfig : QCBaseModel

@property (nonatomic, assign) NSInteger accessibility_status;
@property (nonatomic, copy) NSString *accessibility_white_list;

@end

@interface QCSafConfig : QCBaseModel

@property (nonatomic, assign) NSInteger aliyun_saf_status;

@end

@interface QCAutoHbConfig : QCBaseModel

@property (nonatomic, assign) NSInteger is_open;
@property (nonatomic, assign) NSInteger param1;

@end

NS_ASSUME_NONNULL_END
