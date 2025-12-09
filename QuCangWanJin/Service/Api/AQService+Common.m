//
//  XKDService+Common.m
//  AnswerQuestions
//
//  Created by 陈志远 on 2025/9/19.
//

#import "AQService+Common.h"

@implementation QCService (Common)

+ (void)requestHomeDoGameBind:(NSString *)code
                      success:(QCHTTPRequestResponseSuccessBlock)success
                        error:(QCHTTPRequestResponseErrorBlock)error {
    [self appApiRequestWithApi:@"home/doGameBind" param:@{@"invitation_code":code} success:success failure:error];
}

+ (void)commonVideoFinishUpdTime:(NSString *)logId
                        ecpmInfo:(QCAdEcpmInfoModel *)ecpmInfo
                         success:(QCHTTPRequestResponseSuccessBlock)success
                           error:(QCHTTPRequestResponseErrorBlock)error {
    NSDictionary *param = @{
        @"gold_log_id": logId,
        @"start_time": ecpmInfo.startTime,
        @"end_time": ecpmInfo.endTime,
        @"ad_error1": ecpmInfo.is_error_1 ? @"1" : @"0",
        @"ad_error2": ecpmInfo.is_error_2 ? @"1" : @"0"
    };
    
    [self appApiRequestWithApi:@"common/videoFinishUpdTime" param:param success:success failure:error];
}


+ (void)requestCommonVersion:(QCHTTPRequestResponseSuccessBlock)success error:(QCHTTPRequestResponseErrorBlock)error {
    [self appApiRequestWithApi:@"common/version" param:@{} success:success failure:error];
}

+ (void)getCommedHomeIndexSuccess:(QCHTTPRequestResponseSuccessBlock)success
                            error:(QCHTTPRequestResponseErrorBlock)error {
    [self appApiRequestWithApi:@"home/index" param:@{} success:success failure:error];
}

@end
