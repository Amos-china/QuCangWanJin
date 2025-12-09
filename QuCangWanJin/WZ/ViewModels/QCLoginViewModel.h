#import "QCBaseViewModel.h"
#import "QCUserFirstModel.h"
#import "QCUserModel.h"
#import "QCWechatTokenModel.h"
#import "QCWechatUserInfoModel.h"
#import "QCVersionModel.h"
#import "QCUserSafe.h"
NS_ASSUME_NONNULL_BEGIN

@interface QCLoginViewModel : QCBaseViewModel

@property (nonatomic, strong) QCUserFirstModel *firstModel;

@property (nonatomic, strong) QCUserSafe *userSafe;
@property (nonatomic, strong) QCUserModel *__nullable userModel;
@property (nonatomic, copy) NSString *sendAuthRespCode;

@property (nonatomic, assign) BOOL isInstallWechat;
@property (nonatomic, strong) QCWechatTokenModel *wechatTokenModel;
@property (nonatomic, strong) QCWechatUserInfoModel *wechatUserInfo;

@property (nonatomic, strong) QCVersionModel *versionModel;

- (BOOL)checkFirstInstallApp;
- (BOOL)checkUserLogin;
- (BOOL)checkCanUpdateApp;

- (void)getUserFirstOnSuccess:(OnSuccess)onSuccess error:(QCHTTPRequestResponseErrorBlock)error;

- (void)sendAuthRequestCompletion:(void(^)(BOOL success))completion;
- (void)getWeichatAccessTokenSuccess:(OnSuccess)onSuccess onError:(QCHTTPRequestResponseErrorBlock)onError;

- (void)requestUserCancellation:(OnSuccess)onSuccess onError:(QCHTTPRequestResponseErrorBlock)onError;

- (void)requestVersion:(OnSuccess)onSuccess onError:(QCHTTPRequestResponseErrorBlock)onError;

- (void)loginOut;

- (void)requestApiLoginSuccess:(OnSuccess)success onError:(QCHTTPRequestResponseErrorBlock)onError;


- (void)requestGuidePageNum:(NSInteger)pageNum
                  onSuccess:(OnSuccess)onSuccess
                    onError:(QCHTTPRequestResponseErrorBlock)onError;

- (void)requestUserSafDevicesToken:(NSString *)deviceToken
                           Success:(OnSuccess)success
                             error:(QCHTTPRequestResponseErrorBlock)error;

- (void)requestBindInvitationCode:(NSString *)code onSuccess:(OnSuccess)onSuccess onError:(QCHTTPRequestResponseErrorBlock)onError;

@end

NS_ASSUME_NONNULL_END
