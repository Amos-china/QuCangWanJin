//
//  XKDService+User.h
//  AnswerQuestions
//
//  Created by 陈志远 on 2025/9/19.
//

#import "QCService.h"
#import "QCWechatUserInfoModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface QCService (User)

+ (void)getUserFirstSuccess:(QCHTTPRequestResponseSuccessBlock)success error:(QCHTTPRequestResponseErrorBlock)error;

+ (void)getWechatAccessToken:(NSString *)code success:(QCHTTPRequestSuccessBlock)success error:(QCHTTPRequestFailedBlock)error;

+ (void)requestRefreshWechatToken:(NSString *)refreshToken success:(QCHTTPRequestSuccessBlock)success error:(QCHTTPRequestFailedBlock)error;

+ (void)requestWechatUserInfo:(NSString *)token openid:(NSString *)openId success:(QCHTTPRequestSuccessBlock)success error:(QCHTTPRequestFailedBlock)error;

+ (void)requestApiLoginWithWechatUserInfo:(QCWechatUserInfoModel *)wechatUserInfo success:(QCHTTPRequestResponseSuccessBlock)success error:(QCHTTPRequestResponseErrorBlock)error;

+ (void)requestUserCancellation:(QCHTTPRequestResponseSuccessBlock)success error:(QCHTTPRequestResponseErrorBlock)error;



+ (void)requestUpdGuidePageNum:(NSInteger)num
                       success:(QCHTTPRequestResponseSuccessBlock)success
                         error:(QCHTTPRequestResponseErrorBlock)error;

+ (void)getUserSafDevicesToken:(NSString *)deviceToken
                       Success:(QCHTTPRequestResponseSuccessBlock)success
                         error:(QCHTTPRequestResponseErrorBlock)error;

+ (void)requestUserEqbAppprove:(NSString *)phone
                          name:(NSString *)name
                        idCard:(NSString *)idCard
                       success:(QCHTTPRequestResponseSuccessBlock)success
                         error:(QCHTTPRequestResponseErrorBlock)error;

@end

NS_ASSUME_NONNULL_END
