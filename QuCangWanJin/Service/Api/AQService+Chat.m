//
//  XKDService+Chat.m
//  AnswerQuestions
//
//  Created by 陈志远 on 2025/9/19.
//

#import "AQService+Chat.h"

@implementation QCService (Chat)

+ (void)getChatMsgSuccess:(QCHTTPRequestResponseSuccessBlock)success
                    error:(QCHTTPRequestResponseErrorBlock)error {
    [self appApiRequestWithApi:@"chat/getMsg" param:@{} success:success failure:error];
}



@end
