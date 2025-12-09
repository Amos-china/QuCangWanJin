#import "QCBaseModel.h"
@class QCAdReportModel;
@class QCAdLogType;
@class QCAdMediaIdModel;
@class QCAdInfoConfig;
@class QCAppStartAdConfig;
@class QCAppAdBansModel;
@class QCAppBansConfigModel;
@class QCAdAppErrorConfig;
@class QCConductivityConfig;
@class QCConductivityAppModel;

NS_ASSUME_NONNULL_BEGIN

@interface QCGetAdConfigModel : QCBaseModel

@property (nonatomic, strong) QCAdReportModel *ad_report;
@property (nonatomic, strong) QCAdMediaIdModel *ad_media_id;
@property (nonatomic, strong) NSArray<QCAdInfoConfig *> *topon_ad_list;
@property (nonatomic, strong) NSArray<QCAdInfoConfig *> *gromore_ad_list;
@property (nonatomic, strong) QCAppStartAdConfig *app_start_ad_config;
@property (nonatomic, strong) QCAppStartAdConfig *qhyy_ad_config;
@property (nonatomic, strong) QCAppStartAdConfig *qhcp_config;
@property (nonatomic, strong) QCAppAdBansModel *ad_fj;
@property (nonatomic, strong) NSArray<QCAppBansConfigModel *> *ad_fj_config;
@property (nonatomic, strong) QCAdAppErrorConfig *ad_error_config;
@property (nonatomic, copy) NSString *privacy;
@property (nonatomic, copy) NSString *agreement;
@property (nonatomic, assign) NSInteger agent_is_open;
@property (nonatomic, assign) NSInteger purity;
@property (nonatomic, assign) NSInteger changeControllerShowAdCount;
@property (nonatomic, strong) QCConductivityConfig *dllj_config;

@end

@interface QCAdReportModel : QCBaseModel

@property (nonatomic, copy) NSString *udp_port;
@property (nonatomic, copy) NSString *ad_log_post_type;
@property (nonatomic, copy) NSString *udp_ip;
@property (nonatomic, strong) QCAdLogType *ad_log_type;

@end

@interface QCAdLogType : QCBaseModel

@property (nonatomic, assign) NSInteger show;
@property (nonatomic, assign) NSInteger click;
@property (nonatomic, assign) NSInteger down;
@property (nonatomic, assign) NSInteger install;

@end

@interface QCAdMediaIdModel : QCBaseModel

@property (nonatomic, copy) NSString *to_media_id;
@property (nonatomic, copy) NSString *gm_media_id;
@property (nonatomic, copy) NSString *ks_media_id;
@property (nonatomic, copy) NSString *tx_media_id;
@property (nonatomic, copy) NSString *csj_media_id;

@end
// ----- ----- 

@interface QCAdInfoConfig : QCBaseModel

@property (nonatomic, copy) NSString *infoId;
@property (nonatomic, copy) NSString *position;
@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *zy_code;
@property (nonatomic, assign) NSInteger zy_show_num;

@end

@interface QCAppStartAdConfig : QCBaseModel

@property (nonatomic, assign) NSInteger delayed;
@property (nonatomic, assign) NSInteger ad_status;

@property (nonatomic, assign) NSInteger qp_num;
@property (nonatomic, assign) NSInteger cp_num;

@property (nonatomic, assign) NSInteger page_qh_num;

@property (nonatomic, assign) NSInteger showCount;

@end

@interface QCAppAdBansModel : QCBaseModel

@property (nonatomic, assign) NSInteger kp_fj;
@property (nonatomic, assign) NSInteger sp_fj;
@property (nonatomic, assign) NSInteger cp_fj;
@property (nonatomic, assign) NSInteger hf_fj;
@property (nonatomic, assign) NSInteger xxl_fj;
@property (nonatomic, assign) NSInteger qpsp_fj;
@property (nonatomic, copy) NSString *ad_fj_ts;
@property (nonatomic, assign) NSInteger video_is_max;

@end

@interface QCAppBansConfigModel : QCBaseModel

@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) NSInteger ad_time_hour_value;
@property (nonatomic, assign) NSInteger ad_time_day_value;
@property (nonatomic, assign) NSInteger djl_yz_times_value;
@property (nonatomic, assign) NSInteger djl_yz_bl_value;
@property (nonatomic, assign) NSInteger ad_dj_time_value;

@end

@interface QCAdAppErrorConfig : QCBaseModel

@property (nonatomic, assign) NSInteger continue_ad_num1;
@property (nonatomic, assign) NSInteger continue_ad_num2;
@property (nonatomic, assign) NSInteger ad_time;

@end

@interface QCConductivityConfig : QCBaseModel

@property (nonatomic, copy) NSString *update_content;
@property (nonatomic, assign) NSInteger dl_status;
@property (nonatomic, assign) NSInteger service_close;
@property (nonatomic, strong) NSArray<QCConductivityAppModel *> *dl_app_list;

@end

@interface QCConductivityAppModel : QCBaseModel

@property (nonatomic, assign) NSInteger appId;
@property (nonatomic, assign) NSInteger sort;
@property (nonatomic, copy) NSString *download_link;
@property (nonatomic, copy) NSString *package_name;

@end


NS_ASSUME_NONNULL_END
