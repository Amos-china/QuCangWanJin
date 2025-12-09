//
//  AQXJWithdrawalViewController.m
//  AnswerQuestions
//
//  Created by 陈志远 on 2025/9/15.
//

#import "QCXJWithdrawalViewController.h"
#import "QCCustomDanmaCell.h"
#import "QCCashOutViewModel.h"
#import "QCCashOutSuccessController.h"
@interface QCXJWithdrawalViewController ()<HJDanmakuViewDelegate, HJDanmakuViewDateSource>

@property (weak, nonatomic) IBOutlet UILabel *wxMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *topNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *bottomNumLabel;
@property (weak, nonatomic) IBOutlet UIButton *withdrawalButton;
@property (weak, nonatomic) IBOutlet UILabel *withdrawalDespLabel;
@property (weak, nonatomic) IBOutlet UIView *showDanmuView;
@property (nonatomic, strong) HJDanmakuView *danmakuView;
@property (nonatomic, strong) QCCashOutViewModel *viewModel;
@property (weak, nonatomic) IBOutlet UIView *cashTopView;
@property (nonatomic, assign) BOOL isButtonEnabled;
@property (weak, nonatomic) IBOutlet UILabel *userIdLabel;

@end

@implementation QCXJWithdrawalViewController{
    dispatch_source_t _timer;
    BOOL _timerRunning;
}

- (QCCashOutViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[QCCashOutViewModel alloc] init];
    }
    return _viewModel;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.danmakuView.isPrepared) {
        [self.danmakuView play];
    }
    
    if (self.viewModel.cashOutIndexModel) {
        [self configView];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.danmakuView pause];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isButtonEnabled = YES;

    [self configDanmaView];
    
    [self configView];
    
    [self requestData];
    
    
    QCUserInfoModel *userInfo = [QCUserModel getUserModel].user_info;
    self.userIdLabel.text = SF(@"ID:%@",userInfo.user_id);
}

- (void)requestData {
    [self showHUD];
    __weak typeof(self) weakSelf = self;
    [self.viewModel requestXjCashOutPage:^{
        [weakSelf dismissHUD];
        [weakSelf configView];
        [weakSelf showGuideView];
        [weakSelf playDanma];
    } error:^(NSInteger code, NSString * _Nonnull msg) {
        if (code == SERVICE_REQUEST_ERROR_CODE) {
            [weakSelf dismissHUD];
            [weakSelf showReloadAlertMessage:msg doneButtonAction:^{
                [weakSelf requestData];
            }];
        }else {
            [weakSelf showToast:msg];
        }
        
    }];
}

- (void)playDanma {
    if (self.danmakuView.isPrepared) {
        [self startTimer];
        [self.danmakuView play];
    }
}

- (void)configView {
    self.topNumLabel.text = self.viewModel.topNumText;
    self.bottomNumLabel.text = self.viewModel.bottomNumText;
    self.wxMoneyLabel.text = self.viewModel.canCashMoneyText;
    self.withdrawalDespLabel.attributedText = self.viewModel.ruleAtt;
}

- (void)configDanmaView {
    HJDanmakuConfiguration *config = [[HJDanmakuConfiguration alloc] initWithDanmakuMode:HJDanmakuModeLive];
    config.numberOfLines = 3;
    config.cellHeight = 40.f;
    self.danmakuView = [[HJDanmakuView alloc] initWithFrame:CGRectZero configuration:config];
    self.danmakuView.dataSource = self;
    self.danmakuView.delegate = self;
    [self.danmakuView registerClass:[QCCustomDanmaCell class] forCellReuseIdentifier:@"cell"];
    self.danmakuView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.showDanmuView addSubview:self.danmakuView];
    [self.danmakuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.bottom.mas_equalTo(0);
    }];
    [self.danmakuView prepareDanmakus:nil];
}

- (void)showGuideView {
    if (self.isNewUser) {
        QCGuideMaskView *maskView = [[QCGuideMaskView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [maskView addCashHollowFrame:self.cashTopView.frame buttonFrame:self.withdrawalButton.frame];
        __weak typeof(self) weakSelf = self;
        maskView.touchFrameActionCallBack = ^{
            [weakSelf newUserCashOut];
        };
        [maskView show];
    }
}

- (IBAction)backButtonAction:(id)sender {
    !self.popCallBack? : self.popCallBack();
    [self popViewController];
}

- (IBAction)withdrawalButtonAction:(id)sender {
    if (!self.isButtonEnabled) {
        return;
    }
    self.isButtonEnabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.isButtonEnabled = YES;
    });
    if (self.isNewUser) {
        [self newUserCashOut];
    }else {
        if (self.viewModel.canCash) {
            [self requestCashLog];
        }else {
            [self showToast:@"暂时不可提现"];
        }
    }
}

- (void)requestCashLog {
    __weak typeof(self) weakSelf = self;
    [self showHUD];
    [self.viewModel requstAddFaqiLog:^{
        [weakSelf dismissHUD];
        QCXJWithrawalDetailViewController *vc = [[QCXJWithrawalDetailViewController alloc] init];
        vc.viewModel = weakSelf.viewModel;
        [weakSelf pushViewController:vc];
    } error:^(NSInteger code, NSString * _Nonnull msg) {
        [weakSelf showToast:msg];
    }];
}

- (void)newUserCashOut {
    __weak typeof(self) weakSelf = self;
    [self showHUD];
    [self.viewModel requestDoXjCashOut:^{
        [weakSelf dismissHUD];
        [weakSelf showCsahSuccessController];
    } error:^(NSInteger code, NSString * _Nonnull msg) {
        [weakSelf dismissHUD];
        if (code == SERVICE_REQUEST_ERROR_CODE) {
            [weakSelf showReloadAlertMessage:msg doneButtonAction:^{
                [weakSelf newUserCashOut];
            }];
        }else {
            [weakSelf showToast:msg];
        }
    }];
}

- (void)showCsahSuccessController {
    QCCashOutSuccessController *vc = [[QCCashOutSuccessController alloc] init];
    vc.doCashLog = self.viewModel.doCashLog;
    __weak typeof(self) weakSelf = self;
    vc.dismissCompletion = ^{
        [weakSelf popViewController];
        !weakSelf.popCallBack ? :weakSelf.popCallBack();
    };
    [self presenPopupController:vc];
}

- (void)startTimer {
    // 确保定时器只启动一次
    if (_timerRunning) return;
    _timerRunning = YES;
    
    NSLog(@"定时器启动");
    
    // 创建 GCD 定时器
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    // 设置定时器参数
    uint64_t interval = (uint64_t)(1 * NSEC_PER_SEC); // 5 秒间隔
    uint64_t leeway = (uint64_t)(0.1 * NSEC_PER_SEC);   // 允许误差 0.1 秒
    
    dispatch_source_set_timer(_timer,
                              dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), // 立即开始
                              interval,
                              leeway);
    
    // 设置定时器回调
    __weak typeof(self) weakSelf = self;
    dispatch_source_set_event_handler(_timer, ^{
        if (weakSelf.danmakuView.isPlaying) {
            [weakSelf timerFired];
        }
    });
    
    // 设置定时器取消回调
    dispatch_source_set_cancel_handler(_timer, ^{
        NSLog(@"定时器已取消");
    });
    
    // 启动定时器
    dispatch_resume(_timer);
}

- (void)stopTimer {
    if (_timer) {
        dispatch_source_cancel(_timer);
        _timer = nil;
        _timerRunning = NO;
        NSLog(@"定时器停止");
    }
}

- (void)timerFired {
    // 在这里执行定时任务
    QCXJCashOutTxUserListModel *txModel = [self.viewModel sendUserCashDanma];
    [self addDanmaName:txModel.nickname money:txModel.money face:txModel.face];
}

- (void)addDanmaName:(NSString *)name money:(NSString *)money face:(NSString *)face {
    QCDanmaModel *danmaModel = [[QCDanmaModel alloc] initWithType:HJDanmakuTypeLR];
    danmaModel.url = face;
    money = SF(@"%@元",money);
    NSString *text = SF(@"玩家%@在现金提现页面提现%@",name,money);
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:text];
    att.yy_font = APPFONT(14.f);
    att.yy_color = [UIColor blackColor];
    NSRange nameRange = [text rangeOfString:name];
    [att yy_setColor:[UIColor colorWithHexString:@"#1B9823"] range:nameRange];
    NSRange moenyRange = [text rangeOfString:money];
    [att yy_setColor:[UIColor colorWithHexString:@"#FF3B30"] range:moenyRange];
    danmaModel.att = att;
    [self.danmakuView sendDanmaku:danmaModel forceRender:YES];
}

- (CGFloat)danmakuView:(HJDanmakuView *)danmakuView widthForDanmaku:(HJDanmakuModel *)danmaku {
    QCDanmaModel *model = (QCDanmaModel *)danmaku;
    return 28.f + 8.f + 18.f + [model.att size].width;
}

- (HJDanmakuCell *)danmakuView:(HJDanmakuView *)danmakuView cellForDanmaku:(HJDanmakuModel *)danmaku {
    QCDanmaModel *model = (QCDanmaModel *)danmaku;
    QCCustomDanmaCell *cell = [danmakuView dequeueReusableCellWithIdentifier:@"cell"];
    cell.danmaModel = model;
    return cell;
}

- (void)dealloc {
    [self stopTimer];
    [self.danmakuView stop];
}


@end
