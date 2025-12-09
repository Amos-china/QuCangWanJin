//
//  XKDService+CashOutPage.h
//  AnswerQuestions
//
//  Created by 陈志远 on 2025/9/19.
//

#import "QCService.h"

NS_ASSUME_NONNULL_BEGIN

@interface QCService (CashOutPage)

+ (void)requestCashOutPage:(NSString *)ecpm
                   success:(QCHTTPRequestResponseSuccessBlock)success
                     error:(QCHTTPRequestResponseErrorBlock)error;

+ (void)requestXjCashOutPageSuccess:(QCHTTPRequestResponseSuccessBlock)success
                              error:(QCHTTPRequestResponseErrorBlock)error;

+ (void)requestDoXjCashOutSuccess:(QCHTTPRequestResponseSuccessBlock)success
                            error:(QCHTTPRequestResponseErrorBlock)error;

+ (void)requestAddXjtxFaqiLog:(NSString *)configId
                      success:(QCHTTPRequestResponseSuccessBlock)success
                        error:(QCHTTPRequestResponseErrorBlock)error;

+ (void)requestDoHbCashOutSuccess:(QCHTTPRequestResponseSuccessBlock)success
                            error:(QCHTTPRequestResponseErrorBlock)error;

+ (void)requestDoCashOut:(NSInteger)type
                configId:(NSString *)configId
                 success:(QCHTTPRequestResponseSuccessBlock)success
                   error:(QCHTTPRequestResponseErrorBlock)error;

+ (void)requestGetLog:(NSInteger)type
              success:(QCHTTPRequestResponseSuccessBlock)success
                error:(QCHTTPRequestResponseErrorBlock)error;

+ (void)requestGetJiaYouBaoSuccess:(QCHTTPRequestResponseSuccessBlock)success
                             error:(QCHTTPRequestResponseErrorBlock)error;
@end

NS_ASSUME_NONNULL_END
