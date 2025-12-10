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
                           pic:(NSString *)pic
                       success:(QCHTTPRequestResponseSuccessBlock)success
                         error:(QCHTTPRequestResponseErrorBlock)error {
    NSDictionary *param;
    if (pic.length) {
        param = @{@"type_id": SF(@"%ld",typeId),
                  @"content": content,
                  @"pic": pic};
    }else {
       param = @{@"type_id": SF(@"%ld",typeId),
                 @"content": content};
    }
     
    [self appApiRequestWithApi:@"complaint/doComplaint" param:param success:success failure:error];
}


@end
