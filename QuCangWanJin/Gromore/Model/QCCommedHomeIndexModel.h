//
//  XKDCommedHomeIndexModel.h
//  Mudcon
//
//  Created by 陈志远 on 2025/11/10.
//

#import "QCBaseModel.h"
@class QCAdDownloadConfig;
NS_ASSUME_NONNULL_BEGIN

@interface QCCommedHomeIndexModel : QCBaseModel

@property (nonatomic, strong) QCUserInfoModel *user_info;
@property (nonatomic, strong) QCAppAdBansModel *ad_fj;
@property (nonatomic, strong) QCAdDownloadConfig *ad_download_config;

//米满仓邀请开关状态 1可绑定 2不满足条件 3已绑定 4功能关闭
@property (nonatomic, assign) NSInteger mmc_invite_status;


@end

@interface QCAdDownloadConfig: QCBaseModel

@property (nonatomic, assign) NSInteger xjhb_status;
@property (nonatomic, assign) NSInteger day_num;
@property (nonatomic, assign) NSInteger has_do_num;
@property (nonatomic, copy) NSString *pop_config;
@property (nonatomic, assign) NSInteger sy_num;

@end

NS_ASSUME_NONNULL_END
