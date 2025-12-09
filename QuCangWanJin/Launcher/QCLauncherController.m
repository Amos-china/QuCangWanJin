#import "QCLauncherController.h"
#import "QCUserinfoGuideViewController.h"
#import "QCHomeViewController.h"
#import "QCBaseNavigationController.h"
#import "QCLoginViewModel.h"
#import "AQWebViewController.h"
#import "QCMainTabbarViewController.h"
#import "QCGameMainTabbarController.h"

@interface QCLauncherController ()

@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (nonatomic, strong) QCLoginViewModel *loginViewModel;
@property (weak, nonatomic) IBOutlet UIButton *selectButton;
@property (weak, nonatomic) IBOutlet YYLabel *agreementLabel;

@end


@implementation QCLauncherController

- (QCLoginViewModel *)loginViewModel {
    if (!_loginViewModel) {
        _loginViewModel = [[QCLoginViewModel alloc] init];
    }
    return _loginViewModel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    BOOL firstInstallApp = [[MMKV defaultMMKV] getBoolForKey:k_first_install defaultValue:YES];
    
    [self requestFirst];
    
    if (firstInstallApp) {
        [self showInfoProtectController];
    }else {
        [self requestAdConfig];
        [BDASignalManager startSendingEvents];
        [APPDELEGATE registerUmeng];
    }
    
    __weak typeof(self) weakSelf = self;
    APPDELEGATE.wechatOnResp = ^(BaseResp *resp) {
        if (resp.errCode == 0) {
            SendAuthResp *authResp = (SendAuthResp *)resp;
            weakSelf.loginViewModel.sendAuthRespCode = authResp.code;
            [weakSelf wechatLogin];
        }else if (resp.errCode == -4) {
            [weakSelf showToast:@"用户拒绝授权"];
        }else {
            [weakSelf showToast:@"用户取消授权"];
        }
    };
}

- (void)setUi {
    [self.selectButton setSelected:NO];
    
    self.agreementLabel.hidden = NO;
    self.loginButton.hidden = NO;
    self.selectButton.hidden = NO;
    
    // 原始文本
    NSString *fullText =  @"我已阅读并同意《用户协议》和《隐私政策》";
    
    // 创建 NSMutableAttributedString
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:fullText];
    
    // 设置全局字体和颜色
    attributedString.yy_font = APPFONT(14);
    attributedString.yy_color = [UIColor blackColor];
    
    __weak typeof(self) weakSelf = self;
    // 为《隐私政策》添加下划线和链接
    NSRange privacyRange = [fullText rangeOfString:@"《隐私政策》"];
    [attributedString yy_setTextHighlightRange:privacyRange
                                         color:AppColor
                               backgroundColor:[UIColor clearColor]
                                     tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        NSString *privacy = [QCAdManager sharedInstance].appAdConfigModel.privacy;
        [weakSelf showWebController:@"隐私政策" url:privacy];
    }];
    
    
    // 为《用户协议》添加下划线和链接
    NSRange userAgreementRange = [fullText rangeOfString:@"《用户协议》"];
    [attributedString yy_setTextHighlightRange:userAgreementRange
                                         color:AppColor
                               backgroundColor:[UIColor clearColor]
                                     tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        NSString *userAgreement = [QCAdManager sharedInstance].appAdConfigModel.agreement;
        [weakSelf showWebController:@"用户协议" url:userAgreement];
    }];
    
    self.agreementLabel.attributedText = attributedString;
    self.agreementLabel.backgroundColor = [UIColor clearColor];
}

- (IBAction)checkButtonAction:(id)sender {
    self.selectButton.selected = !self.selectButton.selected;
}

- (void)requestAdConfig {
    __weak typeof(self) weakSelf = self;
    [[QCAdManager sharedInstance] loadAppAdConfigWithSuccess:^{
        [[QCAdManager sharedInstance] loadSplashAd];
        [weakSelf checkAdConfig];
    } error:^(NSString * _Nonnull msg) {
        if ([weakSelf checkUserlogin]) {
            [weakSelf showReloadAlertMessage:msg doneButtonAction:^{
                [weakSelf requestAdConfig];
            }];
        }else {
            [weakSelf loadTabbarController];
        }
    }];
}

- (void)checkAdConfig {
    QCGetAdConfigModel *configModel = [QCAdManager sharedInstance].appAdConfigModel;
    __weak typeof(self) weakSelf = self;
    if (configModel.purity) {
        if ([self checkUserlogin]) {
            [self requestUserLogin];
        }else {
            [self loadSplashAdCompletion:^{
                [weakSelf loadTabbarController];
            }];
        }
    }else {
        if ([self checkUserlogin]) {
            [self requestUserLogin];
        }else {
            //显示登录页面
            [self setUi];
        }
    }
}

- (void)requestFirst {
    [self.loginViewModel getUserFirstOnSuccess:^{
        
    } error:^(NSInteger code, NSString * _Nonnull msg) {
        
    }];
}

- (BOOL)checkUserlogin {
    return self.loginViewModel.userModel;
}

- (void)requestUserLogin {
    __weak typeof(self) weakSelf = self;
    [self showHUD];
    [self.loginViewModel requestApiLoginSuccess:^{
        [weakSelf requestAppVersion];
    } onError:^(NSInteger code, NSString * _Nonnull msg) {
        [weakSelf showToast:msg];
    }];
}

- (void)registerAliYunSafe {
    __weak typeof(self) weakSelf = self;
    [[SecurityDevice sharedInstance] initDevice:k_Aliyun_App_key :^(int status) {
        if (status == 10000) {
            NSString *token = [[SecurityDevice sharedInstance] getDeviceToken].token;
            [weakSelf.loginViewModel requestUserSafDevicesToken:token Success:^{
                if (weakSelf.loginViewModel.userSafe.status == 1) {
                    [weakSelf checkAdStatus];
                }else {
                    [weakSelf dismissHUD];
                    //设备状态 1正常 0封禁 2注销
                    NSString *msg = self.loginViewModel.userSafe.status == 2 ? @"账号已注销" : @"设备封禁";
//                    [weakSelf showExitApplicationAlertMsg:@"设备异常"];
                    [weakSelf showExitApplicationAlertMsg:msg];
                }
            } error:^(NSInteger code, NSString * _Nonnull msg) {
                [weakSelf showToast:SF(@"错误码:%ld\n%@",code,msg)];
            }];
        }
    }] ;
}

- (void)requestAppVersion {
    __weak typeof(self) weakSelf = self;
    [self.loginViewModel requestVersion:^{
        NSInteger appVersionCode = [[AppDeviceInfo getCurrentAppVersionCode] integerValue];
        NSInteger webVersionCode = weakSelf.loginViewModel.versionModel.version_code;
        if (appVersionCode < webVersionCode) {
            [weakSelf dismissHUD];
            [weakSelf updateApp];
        }else {
            [weakSelf requestHome];
            [weakSelf registerAliYunSafe];
        }
    } onError:^(NSInteger code, NSString * _Nonnull msg) {
        [weakSelf dismissHUD];
        [weakSelf showReloadAlertMessage:msg doneButtonAction:^{
            [weakSelf requestAppVersion];
        }];
    }];
}

- (void)requestHome {
    [[QCAdManager sharedInstance] requestHomeIndex:^(QCCommedHomeIndexModel * _Nonnull indexModel) {
        
    } error:^(NSInteger code, NSString * _Nonnull msg) {
        
    }];
}

- (void)checkAdStatus {
    NSInteger status = self.loginViewModel.userModel.user_info.status;
    if (status == 1) {
        [self loadSplashAdCompletion:^{
            [self dismissHUD];
            [self loadMainController];
        }];
        NSDictionary *param = @{kBDADSignalSDKUserUniqueId: self.loginViewModel.userModel.user_info.user_id};
        [BDASignalManager registerWithOptionalData:param];
    }else {
        [self dismissHUD];
        [QCUserModel deleteUserModel];
        NSString *msg = status == 2 ? @"账号已注销" : @"设备封禁";
        [self showExitApplicationAlertMsg:msg];
    }
}

- (void)wechatLogin {
    [self showHUD];
    __weak typeof(self) weakSelf = self;
    [self.loginViewModel getWeichatAccessTokenSuccess:^{
        [weakSelf requestAppVersion];
    } onError:^(NSInteger code, NSString * _Nonnull msg) {
        [weakSelf showToast:SF(@"错误码:%ld\n%@",code,msg)];
    }];
}

//wz
- (void)loadMainController {
//    QCHomeViewController *ahvc = [[QCHomeViewController alloc] init];
//    QCBaseNavigationController *nav = [[QCBaseNavigationController alloc] initWithRootViewController:ahvc];
//    nav.navigationBar.hidden = YES;
//    APPDELEGATE.window.rootViewController = nav;
//    APPDELEGATE.window.rootViewController = [[QCMainTabbarViewController alloc] init];
//    [APPDELEGATE.window makeKeyAndVisible];

    
    [self loadMainTabbarController];
}

//gs
- (void)loadTabbarController {
//    APPDELEGATE.window.rootViewController = [[QCMainTabbarViewController alloc] init];
//    [APPDELEGATE.window makeKeyAndVisible];
    [self loadGameMainTabbarController];
    
}

- (void)loadGameMainTabbarController {
    QCGameMainTabbarController *tabbarVc = [[QCGameMainTabbarController alloc] init];
    APPDELEGATE.window.rootViewController = tabbarVc;
    [APPDELEGATE.window makeKeyAndVisible];
}

- (void)loadMainTabbarController {
    QCMainTabbarViewController *tabbarVc = [[QCMainTabbarViewController alloc] init];
    APPDELEGATE.window.rootViewController = tabbarVc;
    [APPDELEGATE.window makeKeyAndVisible];
}

- (void)showInfoProtectController {
    __weak typeof(self) weakSelf = self;
    [ThreadUtils onUiThreadDelay:0.1 onCompletion:^{
        QCUserinfoGuideViewController *vc = [[QCUserinfoGuideViewController alloc] init];
        vc.dismissCompletion = ^{
            [[MMKV defaultMMKV] setBool:NO forKey:k_first_install];
            [weakSelf requestAdConfig];
            [BDASignalManager startSendingEvents];
            [APPDELEGATE registerUmeng];
        };
        [weakSelf presenClearColorPopupController:vc];
    }];
}

- (IBAction)loginButtonAction:(id)sender {
    if (!self.selectButton.selected) {
        [self showToast:@"请先勾选并同意隐私协议"];
        return;
    }
    
    if (self.loginViewModel.isInstallWechat) {
        __weak typeof(self) weakSelf = self;
        [self.loginViewModel sendAuthRequestCompletion:^(BOOL success) {
            if (!success) {
                [weakSelf showToast:@"微信登录授权失败"];
            }
        }];
    }else {
        [self showToast:@"请安装微信"];
    }
}

- (void)loadSplashAdCompletion:(void(^)(void))completion {
    __weak typeof(self) weakSelf = self;
    [ThreadUtils onUiThreadDelay:3 onCompletion:^{
        [weakSelf dismissHUD];
        BOOL show = [[QCAdManager sharedInstance] showSplashAdCompletionHandler:^(QCAdEcpmInfoModel * _Nonnull ecpmInfoModel) {
            completion();
        }];
        if (!show) {
            completion();
        }
    }];
}

- (void)updateApp {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"更新提示" message:self.loginViewModel.versionModel.update_content preferredStyle:UIAlertControllerStyleAlert];
    __weak typeof(self) weakSelf = self;
    UIAlertAction *updateAction = [UIAlertAction actionWithTitle:@"立即更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf updateAppUrl:weakSelf.loginViewModel.versionModel.download_url];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"稍后" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf showHUD];
        [weakSelf registerAliYunSafe];
    }];
    
    if (!self.loginViewModel.versionModel.force_update) {
        [alertController addAction:cancelAction];
    }
    [alertController addAction:updateAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)showWebController:(NSString *)title url:(NSString *)url {
    AQWebViewController *webController = [[AQWebViewController alloc] init];
    webController.titleText = title;
    webController.url = url;
    [self presentViewController:webController animated:YES completion:nil];
}

@end
