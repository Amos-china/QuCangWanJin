//
//  XKDService+Task.m
//  AnswerQuestions
//
//  Created by 陈志远 on 2025/9/19.
//

#import "AQService+Task.h"

@implementation QCService (Task)

+ (void)requestCashWechat:(NSString *)userId
                     ecpm:(NSString *)ecpm
                   adType:(NSString *)adType
                plateCode:(NSString *)plateCode
                  success:(QCHTTPRequestResponseSuccessBlock)success
                    error:(QCHTTPRequestResponseErrorBlock)error {
    NSDictionary *param = @{@"user_id": userId,
                            @"ecpm": ecpm,
                            @"ad_type": adType,
                            @"plate_code": plateCode};
    [self appApiRequestWithApi:@"task/getCashHbJl" param:param success:success failure:error];
}


+ (void)requstCollectHbGoldAtTask:(NSInteger)task
                    ecpmInfoModel:(QCAdEcpmInfoModel *)ecpmInfoModel
                          success:(QCHTTPRequestResponseSuccessBlock)success
                            error:(QCHTTPRequestResponseErrorBlock)error {
    NSDictionary *params = @{
        @"task_type": SF(@"%ld",task),
        @"ecpm": ecpmInfoModel.ecpm,
        @"ad_type": ecpmInfoModel.adType,
        @"plate_code": ecpmInfoModel.plateCode
    };
    [self appApiRequestWithApi:@"task/collectHbGold" param:params success:success failure:error];
}

@end
