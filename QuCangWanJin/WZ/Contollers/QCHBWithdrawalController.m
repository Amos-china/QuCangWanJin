#import "QCHBWithdrawalController.h"
#import "QCWithdrawalHistoryController.h"
#import "QCHBCashOutPageViewModel.h"
#import "QCCommonToastController.h"
#import "QCCashOutSuccessController.h"
#import "QCRealNameInfoController.h"
#import "QCJoinQQPopupController.h"
@interface QCHBWithdrawalController ()

@property (weak, nonatomic) IBOutlet UILabel *hbMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *wxMoneyLabel;
@property (weak, nonatomic) IBOutlet UIButton *withdrawarButton;
@property (weak, nonatomic) IBOutlet UILabel *withdrawarDespLabel;
@property (nonatomic, strong) QCHBCashOutPageViewModel *viewModel;
@property (weak, nonatomic) IBOutlet UIView *topQQGroupView;
@property (weak, nonatomic) IBOutlet UILabel *topQQNumLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topQQViewHeight;
@property (weak, nonatomic) IBOutlet UILabel *userIdLabel;

@end

@implementation QCHBWithdrawalController

- (QCHBCashOutPageViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[QCHBCashOutPageViewModel alloc] init];
    }
    return _viewModel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadData];
    
    
    QCUserInfoModel *userInfo = [QCUserModel getUserModel].user_info;
    self.userIdLabel.text = SF(@"ID:%@",userInfo.user_id);
}

- (void)loadData {
    __weak typeof(self) weakSelf = self;
    [self showHUD];
    [self.viewModel requestCashOutPage:^{
        [weakSelf dismissHUD];
        [weakSelf configData];
        [weakSelf setupkeFu];
    } error:^(NSInteger code, NSString * _Nonnull msg) {
        if (code == SERVICE_REQUEST_ERROR_CODE) {
            [weakSelf dismissHUD];
            [weakSelf showReloadAlertMessage:msg doneButtonAction:^{
                [weakSelf loadData];
            }];
        }else {
            [weakSelf showToast:msg];
        }
    }];
}


- (void)setupkeFu {
    QCKfConfigModel *kfConfig = self.viewModel.cashOutPageModel.kf_config;
    self.topQQNumLabel.text = kfConfig.qq;
    BOOL canShow = [self.viewModel canShowTopJoinQQView];
    self.topQQGroupView.hidden = !canShow;
    self.topQQViewHeight.constant = canShow ? 56.f : 0.f;
}

- (void)configData {
    self.hbMoneyLabel.text = self.viewModel.totalMoney;
    self.wxMoneyLabel.text = self.viewModel.canCashMoney;
    self.withdrawarDespLabel.attributedText = self.viewModel.ruleAtt;
}

- (IBAction)withdrawarButtonAction:(id)sender {
    NSInteger type = [self.viewModel getCanCashType];
    if (type) {
        CommonToastType toastType = type == 2 ? CommonToastTypeHB : CommonToastTypeCashHB ;
        QCCommonToastController *vc = [[QCCommonToastController alloc] init];
        vc.toastType = toastType;
        vc.contentValue = SF(@"可提现金额不足,满%@元可全部提现",self.viewModel.cashOutPageModel.min_tx_money);
        __weak typeof(self) weakSelf = self;
        vc.dismissCompletion = ^{
            if (toastType == CommonToastTypeHB) {
                [weakSelf popViewController];
            }else {
                !weakSelf.doCashHbCallBack? :weakSelf.doCashHbCallBack();
            }
        };
        [self presenClearColorPopupController:vc];
    }else {
        if ([self.viewModel canCashShowJoinQQController]) {
            [self showJoinQQGruopToast];
        }else {
            [self requestCashOut];
        }
    }
}

- (void)requestCashOut {
    __weak typeof(self) weakSelf = self;
    [self showHUD];
    [self.viewModel requestDoHBCashOut:^{
        [weakSelf dismissHUD];
        [weakSelf requestCashOutSuccess];
        [BDASignalManager trackEssentialEventWithName:kBDADSignalSDKEventPurchase params:@{
            @"pay_amount": @500
        }];
    } error:^(NSInteger code, NSString * _Nonnull msg) {
        [weakSelf showToast:msg];
    }];
}

- (void)requestCashOutSuccess {
    __weak typeof(self) weakSelf = self;
    if (self.viewModel.cashlogModel.need_sm) {
        QCRealNameInfoController *vc = [[QCRealNameInfoController alloc] init];
        vc.viewModel = self.viewModel;
        [self presenClearColorPopupController:vc];
    }else {
        QCCashOutSuccessController *vc = [[QCCashOutSuccessController alloc] init];
        vc.doCashLog = self.viewModel.cashlogModel;
        vc.dismissCompletion = ^{
            !weakSelf.cashOutSuccess? :weakSelf.cashOutSuccess();
            [weakSelf popViewController];
        };
        [self presenClearColorPopupController:vc];
    }
}

- (IBAction)withdrawarHistoryButtonAction:(id)sender {
    QCWithdrawalHistoryController *vc = [[QCWithdrawalHistoryController alloc] init];
    [self pushViewController:vc];
}

- (IBAction)backAction:(id)sender {
    [self popViewController];
}
- (IBAction)joinQQGroupButtonAction:(id)sender {
    [self joinQQ];
}


- (void)showJoinQQGruopToast {
    QCJoinQQPopupController *vc = [[QCJoinQQPopupController alloc] init];
    __weak typeof(self) weakSelf = self;
    vc.dismissCompletion = ^{
        [weakSelf joinQQ];
    };
    [self presenClearColorPopupController:vc];
}

- (void)joinQQ {
    QCKfConfigModel *configModel = self.viewModel.cashOutPageModel.kf_config;
    NSString *urlStr = SF(@"mqqapi://card/show_pslcard?src_type=internal&version=1&uin=%@&key=%@&card_type=group&source=external",configModel.qq,configModel.key);

    NSURL *url = [NSURL URLWithString:urlStr];
    BOOL canOpen = [[UIApplication sharedApplication] canOpenURL:url];
    [self.viewModel setCashShowJoinQQControllerValue];
    if (canOpen) {
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
    }else {
        [self showToast:@"加群失败，可能未安装QQ"];
    }
}

@end
