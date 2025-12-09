//
//  XKDService+User.m
//  AnswerQuestions
//
//  Created by 陈志远 on 2025/9/19.
//

#import "AQService+User.h"
#import "AppDeviceInfo.h"
@implementation QCService (User)

+ (void)getUserFirstSuccess:(QCHTTPRequestResponseSuccessBlock)success error:(QCHTTPRequestResponseErrorBlock)error {
    [self appApiRequestWithApi:@"User/first" param:@{} success:success failure:error];
}

+ (void)getWechatAccessToken:(NSString *)code success:(QCHTTPRequestSuccessBlock)success error:(QCHTTPRequestFailedBlock)error {
    NSDictionary *param = @{
        @"appid": WX_APP_ID,
        @"secret": WX_APP_SECRET,
        @"code": code,
        @"grant_type" : @"authorization_code"
    };
    [self wechatGetRequestApi:@"oauth2/access_token" param:param success:success failure:error];
}

+ (void)requestRefreshWechatToken:(NSString *)refreshToken success:(QCHTTPRequestSuccessBlock)success error:(QCHTTPRequestFailedBlock)error {
    NSDictionary *param = @{
        @"appid": WX_APP_ID,
        @"refresh_token": refreshToken,
        @"grant_type" : @"refresh_token"
    };
    [self wechatGetRequestApi:@"oauth2/refresh_token" param:param success:success failure:error];
}

+ (void)requestWechatUserInfo:(NSString *)token openid:(NSString *)openId success:(QCHTTPRequestSuccessBlock)success error:(QCHTTPRequestFailedBlock)error {
    NSDictionary *param = @{
        @"access_token": token,
        @"openid": openId,
        @"lang" : @"zh_CN"
    };
    [self wechatGetRequestApi:@"userinfo" param:param success:success failure:error];
}

+ (void)requestApiLoginWithWechatUserInfo:(QCWechatUserInfoModel *)wechatUserInfo success:(QCHTTPRequestResponseSuccessBlock)success error:(QCHTTPRequestResponseErrorBlock)error {
    NSString *uuid = [AppDeviceInfo getUIDeviceUUID];
    int simNum = [AppDeviceInfo SimCardNumInPhone];
    
    NSString *openId = wechatUserInfo ? wechatUserInfo.openid : @"openId";
    NSString *unionId = wechatUserInfo ? wechatUserInfo.unionid : @"unionId";
    NSString *nickname = wechatUserInfo ? wechatUserInfo.nickname : @"nickname";
    NSString *headimgurl = wechatUserInfo ? wechatUserInfo.headimgurl : @"headimgurl";
   
    NSString *idfa = [QCAdManager sharedInstance].deviceIDFA;
    
    NSDictionary *param = @{
        @"deviceid": uuid,
        @"phone_model": [CXFactory deviceModelName],
        @"has_sjk" : simNum == 0 ? @"0" : @"1",
        @"openid": openId,
        @"unionid": unionId,
        @"nickname": nickname,
        @"face": headimgurl,
        @"oaid": idfa
    };
    
    [self appApiRequestWithApi:@"user/imeiLogin" param:param success:success failure:error];
}


+ (void)requestUserCancellation:(QCHTTPRequestResponseSuccessBlock)success error:(QCHTTPRequestResponseErrorBlock)error {
    [self appApiRequestWithApi:@"User/cancellation" param:@{} success:success failure:error];
}

+ (void)requestUpdGuidePageNum:(NSInteger)num
                       success:(QCHTTPRequestResponseSuccessBlock)success
                         error:(QCHTTPRequestResponseErrorBlock)error {
    NSDictionary *param = @{
        @"guide_page_num": SF(@"%ld",num)
    };
    [self appApiRequestWithApi:@"User/updGuidePageNum" param:param success:success failure:error];
}

+ (void)getUserSafDevicesToken:(NSString *)deviceToken
                       Success:(QCHTTPRequestResponseSuccessBlock)success
                         error:(QCHTTPRequestResponseErrorBlock)error {
    NSDictionary *param = @{
        @"device_token": deviceToken,
        @"imei_imitate": [AppDeviceInfo getUIDeviceUUID]
    };
    [self appApiRequestWithApi:@"user/getUserSaf" param:param success:success failure:error];
}

+ (void)requestUserEqbAppprove:(NSString *)phone
                          name:(NSString *)name
                        idCard:(NSString *)idCard
                       success:(QCHTTPRequestResponseSuccessBlock)success
                         error:(QCHTTPRequestResponseErrorBlock)error {
    NSDictionary *param = @{@"phone": phone,
                            @"name": name,
                            @"idcard": idCard};
    [self appApiRequestWithApi:@"user/eqbApprove" param:param success:success failure:error];
}

@end
