//
//  XKDService+Task.h
//  AnswerQuestions
//
//  Created by 陈志远 on 2025/9/19.
//

#import "QCService.h"

NS_ASSUME_NONNULL_BEGIN

@interface QCService (Task)

+ (void)requestCashWechat:(NSString *)userId
                     ecpm:(NSString *)ecpm
                   adType:(NSString *)adType
                plateCode:(NSString *)plateCode
                  success:(QCHTTPRequestResponseSuccessBlock)success
                    error:(QCHTTPRequestResponseErrorBlock)error;

+ (void)requstCollectHbGoldAtTask:(NSInteger)task
                    ecpmInfoModel:(QCAdEcpmInfoModel *)ecpmInfoModel
                          success:(QCHTTPRequestResponseSuccessBlock)success
                            error:(QCHTTPRequestResponseErrorBlock)error;

@end

NS_ASSUME_NONNULL_END
