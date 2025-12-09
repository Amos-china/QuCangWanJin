//
//  XKDService+Common.h
//  AnswerQuestions
//
//  Created by 陈志远 on 2025/9/19.
//

#import "QCService.h"

NS_ASSUME_NONNULL_BEGIN

@interface QCService (Common)

+ (void)requestHomeDoGameBind:(NSString *)code
                      success:(QCHTTPRequestResponseSuccessBlock)success
                        error:(QCHTTPRequestResponseErrorBlock)error;

+ (void)commonVideoFinishUpdTime:(NSString *)logId
                        ecpmInfo:(QCAdEcpmInfoModel *)ecpmInfo
                         success:(QCHTTPRequestResponseSuccessBlock)success
                           error:(QCHTTPRequestResponseErrorBlock)error;

+ (void)requestCommonVersion:(QCHTTPRequestResponseSuccessBlock)success error:(QCHTTPRequestResponseErrorBlock)error;

+ (void)getCommedHomeIndexSuccess:(QCHTTPRequestResponseSuccessBlock)success
                            error:(QCHTTPRequestResponseErrorBlock)error;

@end

NS_ASSUME_NONNULL_END
