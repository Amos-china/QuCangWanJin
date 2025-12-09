#import "AQService+AD.h"

@implementation QCService (AD)

+ (void)getAdConfigSuccess:(QCHTTPRequestResponseSuccessBlock)success
                     error:(QCHTTPRequestResponseErrorBlock)error {
    NSString *uuid = [AppDeviceInfo getUIDeviceUUID];
    NSDictionary *param = @{
        @"deviceid": uuid
    };
    [self appApiRequestWithApi:@"ad/getAdConfig" param:param success:success failure:error];
}

+ (void)adProhibitUserLogAddLogPosition:(NSString *)position
                                   code:(NSString *)code
                             clientType:(NSInteger)clientType
                                showNum:(NSInteger)showNum
                               touchNum:(NSInteger)touchNum
                                Success:(QCHTTPRequestResponseSuccessBlock)success
                                  error:(QCHTTPRequestResponseErrorBlock)error {
    NSDictionary *param = @{
        @"ad_position": position,
        @"ad_code": code,
        @"client_type": SF(@"%ld",clientType),
        @"ad_zx_num": SF(@"%ld",showNum),
        @"ad_dj_num": SF(@"%ld",touchNum)
    };
    [self appApiRequestWithApi:@"ad_prohibit_user_log/addLog" param:param success:success failure:error];
}


@end
