#import "QCWechatUserInfoModel.h"

#define k_MMKV_WECHAT_USER_INFO @"k_MMKV_WECHAT_USER_INFO"

@implementation QCWechatUserInfoModel

+ (void)saveWechatUserInfo:(QCWechatUserInfoModel *)userInfo {
    NSString *wechatUserInfoStr = [userInfo toJSONString];
    [[MMKV defaultMMKV] setString:wechatUserInfoStr forKey:k_MMKV_WECHAT_USER_INFO];
}

+ (QCWechatUserInfoModel *)getWechatUserInfo {
    NSString *wechatUserInfoStr = [[MMKV defaultMMKV] getStringForKey:k_MMKV_WECHAT_USER_INFO];
    return [QCWechatUserInfoModel modelWithkeyValues:wechatUserInfoStr];
}

@end
