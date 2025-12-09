#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^OnSuccess)(void);

@interface QCBaseViewModel : NSObject

@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger num;
@property (nonatomic, assign) BOOL hasMore;

- (void)uploadAdTimeWithLogId:(NSString *)logId ecpmInfo:(QCAdEcpmInfoModel *)ecpmInfo;

@end

NS_ASSUME_NONNULL_END
