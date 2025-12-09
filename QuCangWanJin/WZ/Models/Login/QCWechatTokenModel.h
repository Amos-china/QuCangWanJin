#import "QCBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface QCWechatTokenModel : QCBaseModel

@property (nonatomic, copy) NSString *access_token;
@property (nonatomic, copy) NSString *refresh_token;
@property (nonatomic, copy) NSString *openid;
@property (nonatomic, copy) NSString *scope;
@property (nonatomic, copy) NSString *unionid;
@property (nonatomic, assign) NSInteger expires_in;

@property (nonatomic, assign) NSInteger errcode;
@property (nonatomic, copy) NSString *errmsg;

@end

NS_ASSUME_NONNULL_END
