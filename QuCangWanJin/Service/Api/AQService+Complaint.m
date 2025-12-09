//
//  XKDService+Complaint.m
//  AnswerQuestions
//
//  Created by 陈志远 on 2025/9/19.
//

#import "AQService+Complaint.h"

@implementation QCService (Complaint)


+ (void)requestComplaintTypeId:(NSInteger)typeId
                       content:(NSString *)content
                       success:(QCHTTPRequestResponseSuccessBlock)success
                         error:(QCHTTPRequestResponseErrorBlock)error {
    NSDictionary *param = @{@"type_id": SF(@"%ld",typeId),
                            @"content": content};
    [self appApiRequestWithApi:@"complaint/doComplaint" param:param success:success failure:error];
}


@end
