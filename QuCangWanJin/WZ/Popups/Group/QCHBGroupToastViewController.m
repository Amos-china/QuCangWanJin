#import "QCHBGroupToastViewController.h"

@interface QCHBGroupToastViewController ()

@property (weak, nonatomic) IBOutlet UIView *coverView;
@property (weak, nonatomic) IBOutlet UIImageView *coverUserIM;
@property (weak, nonatomic) IBOutlet UILabel *coverUserMsgLabel;

@property (weak, nonatomic) IBOutlet UIImageView *userIM;
@property (weak, nonatomic) IBOutlet UILabel *userMsgLabel;
@property (weak, nonatomic) IBOutlet UILabel *bigMoneyLabel;
@property (weak, nonatomic) IBOutlet UIImageView *meIM;
@property (weak, nonatomic) IBOutlet UILabel *miniMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *meNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (nonatomic, strong) QCGroupMessageModel *msgModel;

@property (weak, nonatomic) IBOutlet UIView *showAdView;
@property (weak, nonatomic) IBOutlet UIButton *openButton;

@end

@implementation QCHBGroupToastViewController

- (instancetype)init {
    if (self = [super init]) {
        self.contentSizeInPopup = [UIScreen mainScreen].bounds.size;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.msgModel = [self.viewModel getSelectMessageModel];
    
    [self configCoverView];
    
    [self configContentView];
    
    BUMCanvasView *adView = [[QCAdManager sharedInstance] getNativeADViewWithController:self];
    if (adView) {
        [self.showAdView addSubview:adView];
        
        [adView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.bottom.mas_equalTo(0);
        }];
    }
    
    [self.openButton beginEnlargeAnimation];
    
}

- (void)configCoverView {
    [self.coverUserIM setImageWithURLString:self.msgModel.face];
}

- (void)configContentView {
    [self.userIM setImageWithURLString:self.msgModel.face];
    self.userMsgLabel.text = SF(@"%@发出的红包",self.msgModel.nickname);
    QCUserModel *userModel = [QCUserModel getUserModel];
    QCUserInfoModel *userInfo = userModel.user_info;
    [self.meIM setImageWithURLString:userInfo.face];
    self.meNameLabel.text = userInfo.nickname;
    self.timeLabel.text = [NSDate getCurrentHHmmTime];
}

- (void)configMoney:(NSString *)money {
    self.bigMoneyLabel.text = money;
    self.miniMoneyLabel.text = money;
}

- (IBAction)openButtonAction:(id)sender {
    [self playDaKaiHb];
    __weak typeof(self) weakSelf = self;
    [self showRewardAdAtCustomToast:@"观看完整视频\n领取大额奖励" close:^(QCAdEcpmInfoModel * _Nonnull ecpmInfoModel) {
        if (ecpmInfoModel.isGiveReward) {
            [weakSelf requstCollectGold:ecpmInfoModel];
        }else {
            [weakSelf showToast:@"要完整观看视频才有奖励哦~"];
        }
        } error:^(NSInteger code, NSString * _Nonnull msg) {
            [weakSelf showToast:msg];
        }];
}

- (void)requstCollectGold:(QCAdEcpmInfoModel *)ecpmInfo {
    __weak typeof(self) weakSelf = self;
    [self showHUD];
    [self.viewModel requestCollectTask:8 ecpmInfo:ecpmInfo success:^{
        [weakSelf dismissHUD];
        NSString *money = self.viewModel.collectGoldModel.get_gold_money;
        [weakSelf configMoney:SF(@"%@元",money)];
        weakSelf.coverView.hidden = YES;
    } error:^(NSInteger code, NSString * _Nonnull msg) {
        if (code == SERVICE_REQUEST_ERROR_CODE) {
            [weakSelf showReloadAlertMessage:msg doneButtonAction:^{
                [weakSelf requstCollectGold:ecpmInfo];
            }];
        }else {
            [weakSelf showToast:msg];
        }
    }];
}

- (IBAction)closeButtonAction:(id)sender {
    [self playTouchButtonSound];
    [self popupControllerDismiss];
}

- (IBAction)collectButtonAction:(id)sender {
    [self playTouchButtonSound];
    [self popupControllerDismissWithCompletion:self.dismissCompletion];
}

@end
