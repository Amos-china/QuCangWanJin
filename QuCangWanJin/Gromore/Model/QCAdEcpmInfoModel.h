#import "QCBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface QCAdEcpmInfoModel : QCBaseModel

@property (nonatomic, copy) NSString *ecpm;
@property (nonatomic, copy) NSString *adType;
@property (nonatomic, copy) NSString *plateCode;
@property (nonatomic, assign) BOOL isGiveReward;
@property (nonatomic, assign) BOOL is_error_1;
@property (nonatomic, assign) BOOL is_error_2;
@property (nonatomic, copy) NSString *startTime;
@property (nonatomic, copy) NSString *endTime;

//---
// 第三方平台的unitid
@property (nonatomic, assign) NSInteger network_placement_id;
//参考Network Firm Id Table
@property (nonatomic, assign) NSInteger network_firm_id;
// eCPM 货币单位
@property (nonatomic, assign) float adsource_price;

+ (NSString *)networkFirmId:(NSInteger)type;
+ (NSString *)gromoreAdType:(NSString *)adnName;

@end

NS_ASSUME_NONNULL_END
