#import "QCGetAdConfigModel.h"

@implementation QCGetAdConfigModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{
        @"topon_ad_list" : [QCAdInfoConfig class],
        @"ad_fj_config" : [QCAppBansConfigModel class],
        @"gromore_ad_list": [QCAdInfoConfig class]
    };
}

@end


@implementation QCAdReportModel

- (NSString *)udp_port {
    return @"41234";
}

@end


@implementation QCAdLogType

@end


@implementation QCAdMediaIdModel

@end

@implementation QCAdInfoConfig

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
        @"infoId" : @"id"
    };
}

@end

@implementation QCAppStartAdConfig

@end

@implementation QCAppAdBansModel

@end

@implementation QCAppBansConfigModel

@end

@implementation QCAdAppErrorConfig

@end

@implementation QCConductivityConfig
+ (NSDictionary *)mj_objectClassInArray {
    return @{
        @"dl_app_list" : [QCConductivityAppModel class]
    };
}


@end

@implementation QCConductivityAppModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
        @"appId" : @"id"
    };
}

@end
