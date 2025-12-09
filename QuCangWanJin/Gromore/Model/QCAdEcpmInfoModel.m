#import "QCAdEcpmInfoModel.h"

@implementation QCAdEcpmInfoModel

+ (NSString *)networkFirmId:(NSInteger)type {
    ////广告平台 csj:穿山甲 tx:腾讯 ks:快手
    switch (type) {
        case 8:
            return @"tx";
        case 15:
            return @"csj";
        case 28:
            return @"ks";
        case 46:
            return @"csj";
        case 22:
            return @"bd";
        case 66:
            return @"topon";
        case 29:
            return @"sigmob";
        default:
            return SF(@"%ld",type);
    }
}


+ (NSString *)gromoreAdType:(NSString *)adnName {
    if ([adnName isEqualToString:@"pangle"]) {
        return @"csj";
    }else if ([adnName isEqualToString:@"gdt"]) {
        return @"tx";
    }else if ([adnName isEqualToString:@"ks"]) {
        return @"ks";
    }else if ([adnName isEqualToString:@"baidu"]) {
        return @"bd";
    }else {
        return @"csj";
    }
}

@end
