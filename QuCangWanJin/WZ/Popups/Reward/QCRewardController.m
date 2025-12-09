#import "QCRewardController.h"
#import "SDAnimatedImageView+Anidmated.h"
@interface QCRewardController ()

@property (weak, nonatomic) IBOutlet UIImageView *titleIM;
@property (weak, nonatomic) IBOutlet UIView *xjView;
@property (weak, nonatomic) IBOutlet UIView *hbView;
@property (weak, nonatomic) IBOutlet UILabel *xjMoney;
@property (weak, nonatomic) IBOutlet UIButton *allcollectButton;
@property (weak, nonatomic) IBOutlet UIView *onlyOneButton;
@property (weak, nonatomic) IBOutlet UIView *onlyOneView;
@property (weak, nonatomic) IBOutlet SDAnimatedImageView *gifIM;
@property (nonatomic, assign) BOOL isClickButton;
@property (weak, nonatomic) IBOutlet UIImageView *wxZgIM;
@property (weak, nonatomic) IBOutlet UIImageView *wxIM;
@property (weak, nonatomic) IBOutlet UIView *adView;
@property (weak, nonatomic) IBOutlet UILabel *useridLabel;
@property (weak, nonatomic) IBOutlet UIImageView *topLineIM;


@end

@implementation QCRewardController

- (instancetype)init {
    if (self = [super init]) {
        self.contentSizeInPopup = [UIScreen mainScreen].bounds.size;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    QCUserInfoModel *userInfoModel = [QCUserModel getUserModel].user_info;
    self.useridLabel.text = SF(@"ID:%@",userInfoModel.user_id);
    
    [self playTanchuang];
    
    [self.topLineIM viewNonstopRotationAnimation];
    
    if (self.rewardType == AQRewardTypeNewUser) {
        self.gifIM.hidden = NO;
        self.onlyOneView.hidden = YES;
        self.titleIM.image = [UIImage imageNamed:@"jl-title-cgcg-im"];
        self.hbView.hidden = YES;
        self.xjMoney.text = SF(@"%@元",self.indexViewModel.answerIndexModel.xj_money);
        [self.allcollectButton setTitle:@"去领取" forState:UIControlStateNormal];
        [self.gifIM displayLocalGIFWithImageName:@"yindao_shouzhi"];
        self.wxZgIM.hidden = YES;
        [self.wxIM setImage:[UIImage imageNamed:@"tx_xs_wx_im"]];
    }else {
        NSString *titleImage = self.indexViewModel.checkRelations ? @"jl-title-cgcg-im" : @"jl-title-im";
        self.titleIM.image = [UIImage imageNamed:titleImage];
        QCAppStartAdConfig *config = [QCAdManager sharedInstance].appAdConfigModel.app_start_ad_config;
        if (config.ad_status) {
            __weak typeof(self) weakSelf = self;
            [ThreadUtils onUiThreadDelay:config.delayed onCompletion:^{
                if (!weakSelf.isClickButton) {
                    [weakSelf showSettlementSwitchAd];
                }
            }];
        }
        
        [self.allcollectButton setImage:[UIImage imageNamed:@"jl_xq_shipin"] forState:UIControlStateNormal];
        
        BUMCanvasView *canvasView = [[QCAdManager sharedInstance] getNativeADViewWithController:self];
        if (canvasView) {
            [self.adView addSubview:canvasView];
            [canvasView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.left.right.bottom.mas_equalTo(0);
            }];
        }
   
    }
    
    [self.allcollectButton beginEnlargeAnimation];
}


- (IBAction)allCollectButtonAction:(id)sender {
    self.isClickButton = YES;
    [self playDaKaiHb];
    if (self.rewardType == AQRewardTypeNewUser) {
        [self popupControllerDismissWithCompletion:self.dismissCompletion];
    }else {
        self.indexViewModel.collectGoldType = QCCollectGoldTypeMax;
        [self collectGold];
    }
}


- (IBAction)onlyOneButtonAction:(id)sender {
    self.isClickButton = YES;
    [self playTouchButtonSound];
    if ([self.indexViewModel checkCollectAutoGold]) {
        self.indexViewModel.collectGoldType = QCCollectGoldTypeAuto;
    }else {
        self.indexViewModel.collectGoldType = QCCollectGoldTypeMin;
    }
    [self collectGold];
}

- (void)collectGold {
    __weak typeof(self) weakSelf = self;
    [self collectGoldOnSuccess:^{
        [weakSelf dismissHUD];
        [weakSelf popupControllerDismissWithCompletion:weakSelf.dismissCompletion];
    } onError:^(NSInteger code, NSString * _Nonnull msg) {
        if (weakSelf.indexViewModel.collectGoldType == QCCollectGoldTypeAuto && code == 101) {
            weakSelf.indexViewModel.collectGoldType = QCCollectGoldTypeMin;
            [weakSelf collectGold];
        }else {
            if (weakSelf.indexViewModel.collectGoldType == QCCollectGoldTypeAuto && code == 102) {
                weakSelf.indexViewModel.collectGoldType = QCCollectGoldTypeMin;
                !weakSelf.autoDismiss? :weakSelf.autoDismiss();
                [weakSelf popupControllerDismiss];
            }else {
                if (code == 103) {
                    [weakSelf showReloadAlertMessage:msg doneButtonAction:^{
                        [weakSelf collectGold];
                    }];
                }else {
                    [weakSelf showToast:msg];
                }
            }
        }
    }];
}

- (void)collectGoldOnSuccess:(OnSuccess)onSuccess onError:(QCHTTPRequestResponseErrorBlock)onError {
    __weak typeof(self) weakSelf = self;
    if (self.indexViewModel.collectGoldType == QCCollectGoldTypeMin) {
        [self requestCollectGold:nil success:onSuccess];
    }else {
        [self showRewardAdAtCustomToast:@"观看完整视频\n领取大额奖励" close:^(QCAdEcpmInfoModel * _Nonnull ecpmInfoModel) {
            if (ecpmInfoModel.isGiveReward) {
                [weakSelf requestCollectGold:ecpmInfoModel success:onSuccess];
            }else {
                [weakSelf showToast:@"完整看完视频才有奖励哦~"];
            }
        } error:onError];
    }
}

- (void)requestCollectGold:(QCAdEcpmInfoModel *)infoModel success:(OnSuccess)success {
    __weak typeof(self) weakSelf = self;
    [self showHUD];
    [self requestCollectGold:infoModel success:success error:^(NSInteger code, NSString * _Nonnull msg) {
        if (code == SERVICE_REQUEST_ERROR_CODE) {
            [weakSelf dismissHUD];
            [weakSelf showReloadAlertMessage:msg doneButtonAction:^{
                [weakSelf requestCollectGold:infoModel success:success];
            }];
        }else {
            [weakSelf showToast:msg];
        }
    }];
}

- (void)requestCollectGold:(QCAdEcpmInfoModel *)infoModel success:(OnSuccess)success error:(QCHTTPRequestResponseErrorBlock)error {
    if (self.indexViewModel.collectGoldType == QCCollectGoldTypeMin) {
        [self.indexViewModel requestMinCollectSuccess:success error:error];
    }else if (self.indexViewModel.collectGoldType == QCCollectGoldTypeAuto) {
        [self.indexViewModel requestAutoCollectGold:infoModel Success:success error:error];
    }else {
        [self.indexViewModel requestAutoCollectGold:infoModel Success:success error:error];
    }
}

@end
