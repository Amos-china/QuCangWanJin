#import "QCLoginViewModel.h"
#import "AQService+User.h"
#import "AQService+Common.h"
@implementation QCLoginViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        _userModel = [QCUserModel getUserModel];
        _wechatUserInfo = [QCWechatUserInfoModel getWechatUserInfo];
    }
    return self;
}

- (BOOL)checkFirstInstallApp {
    return [[MMKV defaultMMKV] getBoolForKey:k_first_install defaultValue:YES];
}

- (BOOL)checkUserLogin {
    return self.userModel ? YES : NO;
}

- (BOOL)checkCanUpdateApp {
    NSInteger appVersionCode = [[AppDeviceInfo getCurrentAppVersionCode] integerValue];
    NSInteger webVersionCode = self.versionModel.version_code;
    return appVersionCode < webVersionCode;
}

- (void)getUserFirstOnSuccess:(OnSuccess)onSuccess error:(QCHTTPRequestResponseErrorBlock)error {
    __weak typeof(self) weakSelf = self;
    [QCService getUserFirstSuccess:^(id  _Nonnull data) {
        weakSelf.firstModel = [QCUserFirstModel modelWithkeyValues:data];
        onSuccess();
    } error:error];
}

- (BOOL)isInstallWechat {
    return [WXApi isWXAppInstalled];
}

- (void)sendAuthRequestCompletion:(void(^)(BOOL success))completion {
    SendAuthReq *rep = [[SendAuthReq alloc] init];
    rep.scope = @"snsapi_userinfo";
    rep.state = @"login";
    [WXApi sendReq:rep completion:^(BOOL success) {
        completion(success);
    }];
}

- (void)getWeichatAccessTokenSuccess:(OnSuccess)onSuccess onError:(QCHTTPRequestResponseErrorBlock)onError {
    __weak typeof(self) weakSelf = self;
    [QCService getWechatAccessToken:self.sendAuthRespCode success:^(NSDictionary * _Nonnull responseObject) {
        weakSelf.wechatTokenModel = [QCWechatTokenModel modelWithkeyValues:responseObject];
        if (weakSelf.wechatTokenModel.errcode == 0) {
            [weakSelf requestWeichatUserInfoSuccess:onSuccess onError:onError];
        }else {
            onError(weakSelf.wechatTokenModel.errcode, weakSelf.wechatTokenModel.errmsg);
        }
    } error:^(NSError * _Nonnull error) {
        onError(error.code, error.localizedFailureReason);
    }];
    
}

- (void)requestWeichatUserInfoSuccess:(OnSuccess)success onError:(QCHTTPRequestResponseErrorBlock)onError {
    __weak typeof(self) weakSelf = self;
    [QCService requestWechatUserInfo:self.wechatTokenModel.access_token
                                   openid:self.wechatTokenModel.openid
                                  success:^(NSDictionary * _Nonnull responseObject) {
        weakSelf.wechatUserInfo = [QCWechatUserInfoModel modelWithkeyValues:responseObject];
        if (weakSelf.wechatUserInfo.errcode == 0) {
            [QCWechatUserInfoModel saveWechatUserInfo:weakSelf.wechatUserInfo];
            [weakSelf requestApiLoginSuccess:success onError:onError];
        }else {
            onError(weakSelf.wechatUserInfo.errcode, weakSelf.wechatUserInfo.errmsg);
        }
    } error:^(NSError * _Nonnull error) {
        onError(error.code , error.localizedFailureReason);
    }];
}

- (void)requestApiLoginSuccess:(OnSuccess)success onError:(QCHTTPRequestResponseErrorBlock)onError {
    __weak typeof(self) weakSelf = self;
    [QCService requestApiLoginWithWechatUserInfo:self.wechatUserInfo success:^(id  _Nonnull data) {
        weakSelf.userModel = [QCUserModel modelWithkeyValues:data];
        weakSelf.userModel.loginType = 1;
        [QCUserModel saveUserModel:weakSelf.userModel];
        success();
    } error:onError];
}


- (void)loginOut {
    [QCUserModel deleteUserModel];
}

- (void)requestUserCancellation:(OnSuccess)onSuccess onError:(QCHTTPRequestResponseErrorBlock)onError {
    __weak typeof(self) weakSelf = self;
    [QCService requestUserCancellation:^(id  _Nonnull data) {
        [weakSelf loginOut];
        onSuccess();
    } error:onError];
}

- (void)requestGuidePageNum:(NSInteger)pageNum
                  onSuccess:(OnSuccess)onSuccess
                    onError:(QCHTTPRequestResponseErrorBlock)onError {
    [QCService requestUpdGuidePageNum:pageNum success:^(id  _Nonnull data) {
        onSuccess();
    } error:onError];
}

- (void)requestUserSafDevicesToken:(NSString *)deviceToken
                           Success:(OnSuccess)success
                             error:(QCHTTPRequestResponseErrorBlock)error {
    __weak typeof(self) weakSelf = self;
    [QCService getUserSafDevicesToken:deviceToken Success:^(id  _Nonnull data) {
        weakSelf.userSafe = [QCUserSafe modelWithkeyValues:data];
        success();
    } error:error];
}

- (void)requestVersion:(nonnull OnSuccess)onSuccess
               onError:(nonnull QCHTTPRequestResponseErrorBlock)onError {
    __weak typeof(self) weakSelf = self;
    [QCService requestCommonVersion:^(id  _Nonnull data) {
        weakSelf.versionModel = [QCVersionModel modelWithkeyValues:data];
        onSuccess();
    } error:onError];
}

- (void)requestBindInvitationCode:(NSString *)code onSuccess:(OnSuccess)onSuccess onError:(QCHTTPRequestResponseErrorBlock)onError {
    [QCService requestHomeDoGameBind:code success:^(id  _Nonnull data) {
        onSuccess();
    } error:onError];
}

@end
