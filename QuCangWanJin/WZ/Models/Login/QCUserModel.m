#import "QCUserModel.h"

#define k_MMKV_USER_MODEL @"k_MMKV_USER_MODEL"

@implementation QCUserModel

+ (void)saveUserModel:(QCUserModel *)userModel {
    NSString *userModelStr = [userModel toJSONString];
    [[MMKV defaultMMKV] setString:userModelStr forKey:k_MMKV_USER_MODEL];
}

+ (QCUserModel *)getUserModel {
    if ([[MMKV defaultMMKV] containsKey:k_MMKV_USER_MODEL]) {
       NSString *userModelStr = [[MMKV defaultMMKV] getStringForKey:k_MMKV_USER_MODEL];
       return [QCUserModel modelWithkeyValues:userModelStr];
    }else {
        return nil;
    }
}

+ (void)updateUserInfoModel:(QCUserInfoModel *)userInfoModel {
    QCUserModel *userModel = [self getUserModel];
    if (userModel) {
        userModel.user_info = userInfoModel;
    }
    [self saveUserModel:userModel];
}

+ (void)deleteUserModel {
    if ([[MMKV defaultMMKV] containsKey:k_MMKV_USER_MODEL]) {
        [[MMKV defaultMMKV] removeValueForKey:k_MMKV_USER_MODEL];
    }
}

@end

@implementation QCAccessibilityConfig

@end

@implementation QCSafConfig

@end

@implementation QCAutoHbConfig

@end
