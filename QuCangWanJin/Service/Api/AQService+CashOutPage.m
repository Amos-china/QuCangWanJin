//
//  XKDService+CashOutPage.m
//  AnswerQuestions
//
//  Created by 陈志远 on 2025/9/19.
//

#import "AQService+CashOutPage.h"

@implementation QCService (CashOutPage)

+ (void)requestCashOutPage:(NSString *)ecpm
                   success:(QCHTTPRequestResponseSuccessBlock)success
                     error:(QCHTTPRequestResponseErrorBlock)error {
    NSString *value = @"0";
    if (ecpm) {
        value = ecpm;
    }
    [self appApiRequestWithApi:@"cash_out/cashOutPage"
                               param:@{@"kp_ecpm":value}
                             success:success
                             failure:error];
}

+ (void)requestXjCashOutPageSuccess:(QCHTTPRequestResponseSuccessBlock)success
                              error:(QCHTTPRequestResponseErrorBlock)error {
    [self appApiRequestWithApi:@"cash_out/xjCashOutPage"
                               param:@{}
                             success:success
                             failure:error];
}

+ (void)requestDoXjCashOutSuccess:(QCHTTPRequestResponseSuccessBlock)success
                            error:(QCHTTPRequestResponseErrorBlock)error {
    [self appApiRequestWithApi:@"cash_out/doXjCashOut"
                               param:@{}
                             success:success
                             failure:error];
}


+ (void)requestAddXjtxFaqiLog:(NSString *)configId
                      success:(QCHTTPRequestResponseSuccessBlock)success
                        error:(QCHTTPRequestResponseErrorBlock)error {
    [self appApiRequestWithApi:@"cash_out/addXjtxFaqiLog"
                               param:@{@"config_id":configId}
                             success:success
                             failure:error];
}

+ (void)requestDoHbCashOutSuccess:(QCHTTPRequestResponseSuccessBlock)success
                            error:(QCHTTPRequestResponseErrorBlock)error {
    [self appApiRequestWithApi:@"cash_out/doHbCashOut"
                               param:@{}
                             success:success
                             failure:error];
}

+ (void)requestDoCashOut:(NSInteger)type
                configId:(NSString *)configId
                 success:(QCHTTPRequestResponseSuccessBlock)success
                   error:(QCHTTPRequestResponseErrorBlock)error {
    NSDictionary *params = @{
        @"type": SF(@"%ld",type),
        @"config_id": configId
    };
    [self appApiRequestWithApi:@"cash_out/doCashOut"
                               param:params
                             success:success
                             failure:error];
}

+ (void)requestGetLog:(NSInteger)type
              success:(QCHTTPRequestResponseSuccessBlock)success
                error:(QCHTTPRequestResponseErrorBlock)error {
    [self appApiRequestWithApi:@"cash_out/getLog"
                               param:@{@"type": SF(@"%ld",type)}
                             success:success
                             failure:error];
}

+ (void)requestGetJiaYouBaoSuccess:(QCHTTPRequestResponseSuccessBlock)success
                             error:(QCHTTPRequestResponseErrorBlock)error {
    [self appApiRequestWithApi:@"cash_out/getXjjyb" param:@{} success:success failure:error];
}

@end
