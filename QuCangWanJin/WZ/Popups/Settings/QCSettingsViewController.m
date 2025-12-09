#import "QCSettingsViewController.h"
#import "QCCommonToastController.h"
#import "AQWebViewController.h"
#import "QCUnRegisterUserViewController.h"
#import "QCRealNameInfoController.h"
#import "QCLoginViewModel.h"
#import "QCLauncherController.h"
@interface QCSettingsViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *userIconIM;
@property (weak, nonatomic) IBOutlet UILabel *userNameLB;
@property (weak, nonatomic) IBOutlet UILabel *userIdLB;
@property (weak, nonatomic) IBOutlet UIButton *userLevelBt;

@property (nonatomic, strong) QCLoginViewModel *viewModel;

@end

@implementation QCSettingsViewController

- (QCLoginViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[QCLoginViewModel alloc] init];
    }
    return _viewModel;
}

- (instancetype)init {
    if (self = [super init]) {
        CGSize size = [UIImage imageNamed:@"sz-bg"].size;
        self.contentSizeInPopup = size;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configUiData];
    
    [self requestFirst];
    
}

- (void)requestFirst {
    [self.viewModel getUserFirstOnSuccess:^{
        
    } error:^(NSInteger code, NSString * _Nonnull msg) {
        
    }];
}

- (void)configUiData {
    self.userNameLB.text = self.viewModel.userModel.user_info.nickname;
    self.userIdLB.text = SF(@"ID:%@",self.viewModel.userModel.user_info.user_id);
    [self.userIconIM setImageWithURLString:self.viewModel.userModel.user_info.face];
    [self.userLevelBt setTitle:SF(@"%@级",self.viewModel.userModel.user_info.level) forState:UIControlStateNormal];
}

- (IBAction)switchButtonAction:(id)sender {
    
}

- (IBAction)closeButtonAction:(id)sender {
    [self popupControllerDismiss];
}

- (IBAction)copyButtonAction:(id)sender {
    UIPasteboard *board = [UIPasteboard generalPasteboard];
    board.string = self.viewModel.userModel.user_info.user_id;
    [self showToast:@"已复制到剪切板"];
}

- (IBAction)clearDataButtonAction:(id)sender {
    //清除缓存信息
    __weak typeof(self) weakSelf = self;
    [self showAlertControllerMessage:@"是否清除缓存？" doneButtonAction:^{
        [weakSelf showToast:@"缓存已清理"];
    } cancelButtonAction:^{
        
    }];
}

- (IBAction)checkUpdateButtonAction:(id)sender {
    __weak typeof(self) weakSelf = self;
    [self showHUD];
    [self.viewModel requestVersion:^{
        NSInteger localVersion = [AppDeviceInfo getCurrentAppVersionCode].integerValue;
        if (weakSelf.viewModel.versionModel.version_code > localVersion) {
            [weakSelf dismissHUD];
            [weakSelf updateAppUrl:weakSelf.viewModel.versionModel.download_url];
        }else {
            [weakSelf showToast:@"已是最新版本"];
        }
    } onError:^(NSInteger code, NSString * _Nonnull msg) {
        [weakSelf showToast:msg];
    }];
}

- (IBAction)myLevelButtonAction:(id)sender {
    QCCommonToastController *vc = [[QCCommonToastController alloc] init];
    vc.toastType = CommonToastTypeSettingLevel;
    vc.myLevel = self.viewModel.userModel.user_info.level;
    [self.popupController pushViewController:vc animated:YES];
}

- (IBAction)unRegisterButtonAction:(id)sender {
    QCUnRegisterUserViewController *vc = [[QCUnRegisterUserViewController alloc] init];
    vc.viewModel = self.viewModel;
    [self.popupController pushViewController:vc animated:YES];
}

- (IBAction)loginOutButtonAction:(id)sender {
    __weak typeof(self) weakSelf = self;
    [self showAlertControllerMessage:@"是否退出登录？" doneButtonAction:^{
        [weakSelf showHUD];
        [ThreadUtils onUiThreadDelay:1.5 onCompletion:^{
            [weakSelf dismissHUD];
            [weakSelf.viewModel loginOut];
            [weakSelf showLauncherController];
        }];
    } cancelButtonAction:^{
        
    }];
}

- (void)showLauncherController {
    QCLauncherController *vc = [[QCLauncherController alloc] init];
    APPDELEGATE.window.rootViewController = vc;
    [APPDELEGATE.window makeKeyAndVisible];
}

- (IBAction)privacyPolicyButtonAction:(id)sender {
    [self showWebController:@"隐私政策" url:self.viewModel.firstModel.privacy];
}

- (IBAction)userAgreementButtonAction:(id)sender {
    [self showWebController:@"用户协议" url:self.viewModel.firstModel.agreement];
}

- (void)showWebController:(NSString *)title url:(NSString *)url {
    AQWebViewController *vc = [[AQWebViewController alloc] init];
    vc.titleText = title;
    vc.url = url;
    [self presentViewController:vc animated:YES completion:nil];
}


@end
