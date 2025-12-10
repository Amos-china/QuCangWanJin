//
//  XKDService+Complaint.h
//  AnswerQuestions
//
//  Created by 陈志远 on 2025/9/19.
//

#import "QCService.h"

NS_ASSUME_NONNULL_BEGIN

@interface QCService (Complaint)

+ (void)requestComplaintTypeId:(NSInteger)typeId
                       content:(NSString *)content
                           pic:(NSString *)pic
                       success:(QCHTTPRequestResponseSuccessBlock)success
                         error:(QCHTTPRequestResponseErrorBlock)error;

@end

NS_ASSUME_NONNULL_END
