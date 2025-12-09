#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QCBaseModel : NSObject

+ (id)modelWithkeyValues:(id)dict;

- (NSString *)toJSONString;

@end

NS_ASSUME_NONNULL_END
