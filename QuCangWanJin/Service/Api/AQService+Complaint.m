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
                           pic:(NSData *)pic
                       success:(QCHTTPRequestResponseSuccessBlock)success
                         error:(QCHTTPRequestResponseErrorBlock)error {
    NSDictionary *param;
    if (pic) {
        param = @{@"type_id": SF(@"%ld",typeId),
                  @"content": content,
                  @"pic": @""};
    }else {
       param = @{@"type_id": SF(@"%ld",typeId),
                 @"content": content};
    }
    [self appApiUploadImageWithApi:@"complaint/feedback" param:param imageData:pic success:success failure:error];
}


@end
