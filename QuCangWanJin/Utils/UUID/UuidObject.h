#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UuidObject : NSObject

+ (NSString *)getUUID;

+ (NSString *)getCFUUIDCreateUUID;

+ (NSString *)getUIDeviceUUID;

+ (NSString *)getIDFV;

@end

NS_ASSUME_NONNULL_END
