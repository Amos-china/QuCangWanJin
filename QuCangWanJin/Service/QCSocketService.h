

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QCSocketService : NSObject

+ (instancetype)sharedInstance;

- (void)bindPort:(QCAdReportModel *)reportModel;
- (void)sendMessage:(NSString *)message type:(NSInteger)type;

@end

NS_ASSUME_NONNULL_END
