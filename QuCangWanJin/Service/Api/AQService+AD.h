#import "QCService.h"

NS_ASSUME_NONNULL_BEGIN

@interface QCService (AD)

+ (void)getAdConfigSuccess:(QCHTTPRequestResponseSuccessBlock)success
                     error:(QCHTTPRequestResponseErrorBlock)error;

+ (void)adProhibitUserLogAddLogPosition:(NSString *)position
                                   code:(NSString *)code
                             clientType:(NSInteger)clientType
                                showNum:(NSInteger)showNum
                               touchNum:(NSInteger)touchNum
                                Success:(QCHTTPRequestResponseSuccessBlock)success
                                  error:(QCHTTPRequestResponseErrorBlock)error;

@end

NS_ASSUME_NONNULL_END
