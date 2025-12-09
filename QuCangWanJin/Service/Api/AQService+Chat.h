//
//  XKDService+Chat.h
//  AnswerQuestions
//
//  Created by 陈志远 on 2025/9/19.
//

#import "QCService.h"

NS_ASSUME_NONNULL_BEGIN

@interface QCService (Chat)

+ (void)getChatMsgSuccess:(QCHTTPRequestResponseSuccessBlock)success
                    error:(QCHTTPRequestResponseErrorBlock)error;



@end

NS_ASSUME_NONNULL_END
