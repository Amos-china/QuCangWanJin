#import "QCCashWechatViewController.h"
#import "QCCashWechatViewModel.h"
#import "QCCashOutSuccessController.h"
#import "QCLoadingImageView.h"
#import "QCCashWechatSuccessController.h"

@interface QCCashWechatViewController ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *nikeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *cashMoneyLabel;
@property (weak, nonatomic) IBOutlet UIButton *lookButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *statusBarHeight;


@property (nonatomic, strong) dispatch_source_t timer;
@property (nonatomic, assign) UIBackgroundTaskIdentifier backgroundTask;

@property (nonatomic, strong) QCCashWechatViewModel *viewModel;
@property (weak, nonatomic) IBOutlet QCLoadingImageView *stepOneImageView;
@property (weak, nonatomic) IBOutlet QCLoadingImageView *stepTwoImageView;
@property (weak, nonatomic) IBOutlet QCLoadingImageView *stepThreeImageView;
@property (weak, nonatomic) IBOutlet UILabel *stepTwoLabel;
@property (weak, nonatomic) IBOutlet UILabel *stepThreeLabel;

@end

static const NSInteger MAXTIME = 20;

@implementation QCCashWechatViewController

- (QCCashWechatViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[QCCashWechatViewModel alloc] init];
    }
    return _viewModel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.statusBarHeight.constant = STATUS_BAR_HEIGHT;
    
    [self addApplicationActivity];
    
    QCUserModel *userModel = [QCUserModel getUserModel];
    self.nikeNameLabel.text = SF(@"(%@)",userModel.user_info.nickname);
    
    self.stepOneImageView.loadingStatus = GSLoadingImageViewStatusNormal;
    self.stepTwoImageView.loadingStatus = GSLoadingImageViewStatusLoading;
    self.stepThreeImageView.loadingStatus = GSLoadingImageViewStatusGray;
    
    self.stepTwoLabel.textColor = [UIColor colorWithHexString:@"#FF9500"];
    
    self.stepThreeLabel.textColor = [UIColor colorWithHexString:@"#666666"];
}


- (void)addApplicationActivity {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appWillEnterForground:)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appDidEnterBackground:)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
}

- (void)appWillEnterForground:(NSNotification *)notification {
    //进入到前台
    self.viewModel.isEnterBackground = NO;
}

- (void)appDidEnterBackground:(NSNotification *)notification {
    //进入到后台
    if (self.viewModel.isShowAd && self.viewModel.isClickAd) {
        self.viewModel.isEnterBackground = YES;
        [self showToast:@"退到了后台"];
    }
}

- (IBAction)backButtonAction:(id)sender {
    [self popViewController];
}

- (IBAction)lookVideoButtonAction:(id)sender {
    __weak typeof(self) weakSelf = self;
    [self requsetCheckVideoStatus:^{
        [weakSelf showAd];
    }];
}

- (void)requsetCheckVideoStatus:(void(^)(void))videoStatus {
    [self.viewModel reset];
    [self showHUD];
    __weak typeof(self) weakSelf = self;
    
    [[QCAdManager sharedInstance] requestHomeIndex:^(QCCommedHomeIndexModel * _Nonnull indexModel) {
        if (indexModel.user_info.status == 1) {
            if (!indexModel.ad_fj.sp_fj) {
                if (indexModel.ad_fj.video_is_max) {
                    [weakSelf showToast:@"当天视频次数已达上限"];
                }else {
                    [weakSelf dismissHUD];
                    videoStatus();
                }
            }else {
                [weakSelf showToast:@"账号异常,暂无视频"];
            }
        }else {
            NSString *text = @"账号异常,限制登录";
            [weakSelf showExitApplicationAlertMsg:text];
        }
    } error:^(NSInteger code, NSString * _Nonnull msg) {
        [weakSelf showToast:msg];
    }];
}

- (void)showAd {
    __weak typeof(self) weakSelf = self;
    BOOL isShow = [[QCAdManager sharedInstance] showRewardAdWithController:self completionHander:^(QCAdEcpmInfoModel * _Nonnull ecpmInfoModel) {
        //触发定时器关闭
        [weakSelf endTimer];
        [weakSelf cancelBackgroundTask];

        if (weakSelf.viewModel.lookTime < MAXTIME) {
            [weakSelf showToast:SF(@"体验时长不足，请重新开始任务")];
            return;
        }
        
        weakSelf.stepTwoLabel.textColor = [UIColor colorWithHexString:@"#50A547"];
        weakSelf.stepTwoImageView.loadingStatus = GSLoadingImageViewStatusNormal;
        
        weakSelf.stepThreeLabel.textColor = [UIColor colorWithHexString:@"#FF9500"];
        weakSelf.stepThreeImageView.loadingStatus = GSLoadingImageViewStatusLoading;
        
        [weakSelf requestData:ecpmInfoModel];
    } clickAdHander:^{
        weakSelf.viewModel.isClickAd = YES;
    }];
    
    if (!isShow) {
        [self showToast:@"暂无广告"];
    }else {
        [ThreadUtils onUiThreadDelay:0.5 onCompletion:^{
            [self showCustomToast:@"观看完整视频\n下载安装广告中产品\n体验20秒提现"];
        }];
        
        self.viewModel.isShowAd = YES;
        [self startTimer];
    }
}

- (void)requestData:(QCAdEcpmInfoModel *)infoModel {
    __weak typeof(self) weakSelf = self;
    [self showHUD];
    [self.viewModel requestCashWechat:infoModel success:^(QCCashWechatModel * _Nonnull model) {
        [weakSelf dismissHUD];
        if (model.jl_type == 1) {
            //提现
            [weakSelf showRequestWithdrawalController:model.jl_value];
            [BDASignalManager trackEssentialEventWithName:kBDADSignalSDKEventPurchase params:@{
                @"pay_amount": @600
            }];
        }else {
            //奖励
            [weakSelf showGeyValueController:model.jl_value];
        }
        [[QCAdManager sharedInstance] requestHomeIndex:^(QCCommedHomeIndexModel * _Nonnull indexModel) {} error:^(NSInteger code, NSString * _Nonnull msg) {}];
    } error:^(NSInteger code, NSString * _Nonnull msg) {
        [weakSelf showToast:msg];
    }];
}

- (void)showRequestWithdrawalController:(NSString *)money {
    QCWithrawalListModel *docashLog = [[QCWithrawalListModel alloc] init];
    docashLog.tx_money = money;
    __weak typeof(self) weakSelf = self;
    QCCashOutSuccessController *successController = [[QCCashOutSuccessController alloc] init];
    successController.doCashLog = docashLog;
    successController.dismissCompletion = ^{
        !weakSelf.cashSuccessCallBack ? :weakSelf.cashSuccessCallBack();
        [weakSelf popViewController];
    };
    [weakSelf presenPopupController:successController];
}

- (void)showGeyValueController:(NSString *)money {
    QCCashWechatSuccessController *vc = [[QCCashWechatSuccessController alloc] init];
    vc.moneyValue = money;
    __weak typeof(self) weakSelf = self;
    vc.dismissCompletion = ^{
        !weakSelf.cashSuccessCallBack ? :weakSelf.cashSuccessCallBack();
        [weakSelf popViewController];
    };
    [self presenClearColorPopupController:vc];
}

- (void)endTimer {
    if (self.timer) {
        dispatch_source_cancel(self.timer);
        self.timer = nil;
    }
}

- (void)startTimer {
    
    [self endTimer];
    
    __weak typeof(self) weakSelf = self;
    self.backgroundTask = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        [weakSelf endTimer];
        [weakSelf cancelBackgroundTask];
    }];
    // 创建GCD定时器
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    // 设置定时器 (1秒触发一次)
    dispatch_source_set_timer(self.timer, dispatch_time(DISPATCH_TIME_NOW, 0), 1 * NSEC_PER_SEC, 0);
    
    // 设置定时器回调
    dispatch_source_set_event_handler(self.timer, ^{
        if (weakSelf.viewModel.isEnterBackground) {
            weakSelf.viewModel.lookTime ++;
            NSLog(@"---->%ld",weakSelf.viewModel.lookTime);
            if (weakSelf.viewModel.lookTime >= MAXTIME) {
                [weakSelf endTimer];
                [weakSelf cancelBackgroundTask];
            }
        }
    });
    
    // 启动定时器
    dispatch_resume(self.timer);
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self endTimer];
    [self cancelBackgroundTask];
}

- (void)cancelBackgroundTask {
    if (self.backgroundTask != UIBackgroundTaskInvalid) {
        [[UIApplication sharedApplication] endBackgroundTask:self.backgroundTask];
        self.backgroundTask = UIBackgroundTaskInvalid;
    }
}

@end
