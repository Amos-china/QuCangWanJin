#import "UuidObject.h"
#import "KeyChainStore.h"
#import <Security/Security.h>

static NSString *BUNDLE_ID = @"com.mt.melon.hbyf";

@implementation UuidObject


+ (NSString *)getUUID {
    
    NSString * strUUID = (NSString *)[KeyChainStore load:BUNDLE_ID];
    
    //首次执行该方法时，uuid为空
    
    if ([strUUID isEqualToString:@""] || !strUUID) {
        
        //生成一个uuid的方法
        
        CFUUIDRef uuidRef = CFUUIDCreate(kCFAllocatorDefault);
        
        strUUID = (NSString *)CFBridgingRelease(CFUUIDCreateString (kCFAllocatorDefault,uuidRef));
        
        //将该uuid保存到keychain
        
        [KeyChainStore save:BUNDLE_ID data:strUUID];
        
    }
    return strUUID;
}


/**  卸载应用重新安装后会不一致*/
+ (NSString *)getCFUUIDCreateUUID{
    CFUUIDRef uuid = CFUUIDCreate(NULL);
    NSString *UUID = (__bridge_transfer NSString *)CFUUIDCreateString(NULL, uuid);
    CFRelease(uuid);
    return UUID;
}
 
/**  卸载应用重新安装后会不一致*/
+ (NSString *)getUIDeviceUUID{
//    return [UIDevice currentDevice].identifierForVendor.UUIDString;;
    return @"";
}

+ (NSString *)getIDFV {
    if ([[UIDevice currentDevice] respondsToSelector:@selector(identifierForVendor)]) {
            return [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        }
    return @"";
}
 

@end
