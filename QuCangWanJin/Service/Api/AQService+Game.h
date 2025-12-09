//
//  XKDService+Game.h
//  AnswerQuestions
//
//  Created by 陈志远 on 2025/9/19.
//

#import "QCService.h"

NS_ASSUME_NONNULL_BEGIN

@interface QCService (Game)


+ (void)requestUpdGuidePageNum:(NSInteger)num
                       success:(QCHTTPRequestResponseSuccessBlock)success
                         error:(QCHTTPRequestResponseErrorBlock)error;

+ (void)requestIndex:(NSInteger)skip
             success:(QCHTTPRequestResponseSuccessBlock)success
               error:(QCHTTPRequestResponseErrorBlock)error;

+ (void)requestGameAssistant:(NSInteger)page
                     success:(QCHTTPRequestResponseSuccessBlock)success
                       error:(QCHTTPRequestResponseErrorBlock)error;

+ (void)requestGameAssistantUnlock:(NSString *)assistantId
                           success:(QCHTTPRequestResponseSuccessBlock)success
                             error:(QCHTTPRequestResponseErrorBlock)error;

+ (void)requestGameClooseAssistant:(NSString *)assistantId
                           success:(QCHTTPRequestResponseSuccessBlock)success
                             error:(QCHTTPRequestResponseErrorBlock)error;

+ (void)requestCollectNewUserTgGoldAtFisrt:(BOOL)first
                                   success:(QCHTTPRequestResponseSuccessBlock)success
                                     error:(QCHTTPRequestResponseErrorBlock)error;

+ (void)requestCollectFirstTgGold:(QCHTTPRequestResponseSuccessBlock)success
                            error:(QCHTTPRequestResponseErrorBlock)error;

+ (void)requestCollectSecondTgGold:(QCHTTPRequestResponseSuccessBlock)success
                             error:(QCHTTPRequestResponseErrorBlock)error;

+ (void)requestCollectCgGold:(QCAdEcpmInfoModel *)ecpmInfoModel
                     success:(QCHTTPRequestResponseSuccessBlock)success
                       error:(QCHTTPRequestResponseErrorBlock)error;

+ (void)requestCollectTgGold:(QCAdEcpmInfoModel *)ecpmInfoModel
                     success:(QCHTTPRequestResponseSuccessBlock)success
                       error:(QCHTTPRequestResponseErrorBlock)error;

+ (void)requestCollectCgMinGold:(QCHTTPRequestResponseSuccessBlock)success
                          error:(QCHTTPRequestResponseErrorBlock)error;

+ (void)requestCollectTgMinGold:(QCHTTPRequestResponseSuccessBlock)success
                          error:(QCHTTPRequestResponseErrorBlock)error;

+ (void)requestCollectCgAutoFbGold:(QCAdEcpmInfoModel *)ecpmInfoModel
                           success:(QCHTTPRequestResponseSuccessBlock)success
                             error:(QCHTTPRequestResponseErrorBlock)error;

+ (void)requestCollectVideoGold:(BOOL)isRelations
                       ecpmInfo:(QCAdEcpmInfoModel *)ecpmInfo
                        success:(QCHTTPRequestResponseSuccessBlock)success
                          error:(QCHTTPRequestResponseErrorBlock)error;

+ (void)requestCollectMinGold:(BOOL)isRelations
                      success:(QCHTTPRequestResponseSuccessBlock)success
                        error:(QCHTTPRequestResponseErrorBlock)error;

@end

NS_ASSUME_NONNULL_END
