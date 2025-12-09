#import "QCBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface QCWechatUserInfoModel : QCBaseModel

@property (nonatomic, copy) NSString *openid;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, assign) NSInteger sex;
@property (nonatomic, copy) NSString *province;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *country;
@property (nonatomic, copy) NSString *headimgurl;
@property (nonatomic, copy) NSArray<NSString *> *privilege;
@property (nonatomic, copy) NSString *unionid;

@property (nonatomic, assign) NSInteger errcode;
@property (nonatomic, copy) NSString *errmsg;

+ (void)saveWechatUserInfo:(QCWechatUserInfoModel *)userInfo;
+ (QCWechatUserInfoModel *)getWechatUserInfo;

@end

NS_ASSUME_NONNULL_END
