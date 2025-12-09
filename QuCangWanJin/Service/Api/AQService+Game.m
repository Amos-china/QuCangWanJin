//
//  XKDService+Game.m
//  AnswerQuestions
//
//  Created by 陈志远 on 2025/9/19.
//

#import "AQService+Game.h"

@implementation QCService (Game)


+ (void)requestUpdGuidePageNum:(NSInteger)num
                       success:(QCHTTPRequestResponseSuccessBlock)success
                         error:(QCHTTPRequestResponseErrorBlock)error {
    [self appApiRequestWithApi:@"User/updGuidePageNum"
                               param:@{@"guide_page_num": SF(@"%ld",num)}
                             success:success
                             failure:error];
}

+ (void)requestIndex:(NSInteger)skip
             success:(QCHTTPRequestResponseSuccessBlock)success
               error:(QCHTTPRequestResponseErrorBlock)error {
    [self appApiRequestWithApi:@"game/index"
                               param:@{@"skip": SF(@"%ld",skip)}
                             success:success
                             failure:error];
}

+ (void)requestGameAssistant:(NSInteger)page
                     success:(QCHTTPRequestResponseSuccessBlock)success
                       error:(QCHTTPRequestResponseErrorBlock)error {
    [self appApiRequestWithApi:@"game/assistant"
                               param:@{@"page":SF(@"%ld",page)}
                             success:success
                             failure:error];
}

+ (void)requestGameAssistantUnlock:(NSString *)assistantId
                           success:(QCHTTPRequestResponseSuccessBlock)success
                             error:(QCHTTPRequestResponseErrorBlock)error {
    [self appApiRequestWithApi:@"game/assistantUnlock"
                               param:@{@"assistant_id": assistantId}
                             success:success
                             failure:error];
}

+ (void)requestGameClooseAssistant:(NSString *)assistantId
                           success:(QCHTTPRequestResponseSuccessBlock)success
                             error:(QCHTTPRequestResponseErrorBlock)error {
    [self appApiRequestWithApi:@"game/chooseAssistant"
                               param:@{@"assistant_id": assistantId}
                             success:success
                             failure:error];
}

+ (void)requestCollectNewUserTgGoldAtFisrt:(BOOL)first
                                   success:(QCHTTPRequestResponseSuccessBlock)success
                                     error:(QCHTTPRequestResponseErrorBlock)error {
    if (first) {
        [self requestCollectFirstTgGold:success error:error];
    }else {
        [self requestCollectSecondTgGold:success error:error];
    }
}

+ (void)requestCollectFirstTgGold:(QCHTTPRequestResponseSuccessBlock)success
                            error:(QCHTTPRequestResponseErrorBlock)error {
    [self appApiRequestWithApi:@"game/collectFirstTgGold"
                               param:@{}
                             success:success
                             failure:error];
}

+ (void)requestCollectSecondTgGold:(QCHTTPRequestResponseSuccessBlock)success
                             error:(QCHTTPRequestResponseErrorBlock)error {
    [self appApiRequestWithApi:@"game/collectSecondTgGold"
                               param:@{}
                             success:success
                             failure:error];
}

+ (void)requestCollectCgGold:(QCAdEcpmInfoModel *)ecpmInfoModel
                     success:(QCHTTPRequestResponseSuccessBlock)success
                       error:(QCHTTPRequestResponseErrorBlock)error {
    NSDictionary *params = @{
        @"ecpm": ecpmInfoModel.ecpm,
        @"ad_type": ecpmInfoModel.adType,
        @"plate_code": ecpmInfoModel.plateCode
    };
    [self appApiRequestWithApi:@"game/collectCgGold"
                               param:params
                             success:success
                             failure:error];
}

+ (void)requestCollectTgGold:(QCAdEcpmInfoModel *)ecpmInfoModel
                     success:(QCHTTPRequestResponseSuccessBlock)success
                       error:(QCHTTPRequestResponseErrorBlock)error {
    NSDictionary *params = @{
        @"ecpm": ecpmInfoModel.ecpm,
        @"ad_type": ecpmInfoModel.adType,
        @"plate_code": ecpmInfoModel.plateCode
    };
    [self appApiRequestWithApi:@"game/collectTgGold"
                               param:params
                             success:success
                             failure:error];
}


+ (void)requestCollectCgMinGold:(QCHTTPRequestResponseSuccessBlock)success
                          error:(QCHTTPRequestResponseErrorBlock)error {
    [self appApiRequestWithApi:@"game/collectCgMinGold"
                               param:@{}
                             success:success
                             failure:error];
}


+ (void)requestCollectTgMinGold:(QCHTTPRequestResponseSuccessBlock)success
                          error:(QCHTTPRequestResponseErrorBlock)error {
    [self appApiRequestWithApi:@"game/collectTgMinGold"
                               param:@{}
                             success:success
                             failure:error];
}

+ (void)requestCollectMinGold:(BOOL)isRelations
                      success:(QCHTTPRequestResponseSuccessBlock)success
                        error:(QCHTTPRequestResponseErrorBlock)error {
    if (isRelations) {
        [self requestCollectTgMinGold:success error:error];
    }else {
        [self requestCollectCgMinGold:success error:error];
    }
}

+ (void)requestCollectVideoGold:(BOOL)isRelations
                       ecpmInfo:(QCAdEcpmInfoModel *)ecpmInfo
                        success:(QCHTTPRequestResponseSuccessBlock)success
                          error:(QCHTTPRequestResponseErrorBlock)error {
    if (isRelations) {
        [self requestCollectTgGold:ecpmInfo success:success error:error];
    }else {
        [self requestCollectCgGold:ecpmInfo success:success error:error];
    }
}

+ (void)requestCollectCgAutoFbGold:(QCAdEcpmInfoModel *)ecpmInfoModel
                           success:(QCHTTPRequestResponseSuccessBlock)success
                             error:(QCHTTPRequestResponseErrorBlock)error {
    NSDictionary *params = @{
        @"ecpm": ecpmInfoModel.ecpm,
        @"ad_type": ecpmInfoModel.adType,
        @"plate_code": ecpmInfoModel.plateCode
    };
    [self appApiRequestWithApi:@"game/collectCgAutoFbGold"
                               param:params
                             success:success
                             failure:error];
}



@end
