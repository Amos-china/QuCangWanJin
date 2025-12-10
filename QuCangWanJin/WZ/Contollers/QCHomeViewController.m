#import "QCHomeViewController.h"
#import "QCHomeViewController+Audio.h"
#import "QCHomeTopHBView.h"
#import "QCHomeTopXJView.h"
#import "QCGameHomeMusicViewModel.h"
#import "QCAnswerButton.h"
#import "QCSettingsViewController.h"
#import "QCAsisstionViewController.h"
#import "QCXJWithdrawalViewController.h"
#import "QCRewardController.h"
#import "QCRewardDetailController.h"
#import "QCWechatCashPromptController.h"
#import "QCUnLockNewStreamerController.h"
#import "QCCashWechatViewController.h"
#import "QCStartGuideViewController.h"
#import "QCHBWithdrawalController.h"
#import "QCMainTabbarViewController.h"
#import "QCSharePopupViewController.h"
#import "QCCashFeedBackController.h"
@interface QCHomeViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *anchorImageView;
@property (weak, nonatomic) IBOutlet QCHomeTopXJView *xjView;
@property (weak, nonatomic) IBOutlet QCHomeTopHBView *hbView;
@property (weak, nonatomic) IBOutlet UILabel *currentLevelNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentLevelMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentLevelProgressLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *levelProgressView;
@property (weak, nonatomic) IBOutlet QCAnswerButton *muiscOneButton;
@property (weak, nonatomic) IBOutlet QCAnswerButton *musicTwoButton;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;

@property (nonatomic, strong) QCGameHomeMusicViewModel *indexViewModel;
@property (weak, nonatomic) IBOutlet UIView *hbPopupView;
@property (weak, nonatomic) IBOutlet UIView *wxPopupView;
@property (weak, nonatomic) IBOutlet UILabel *wxPopupLabel;

@property (nonatomic, strong) LOTAnimationView *xjAnimationView;
@property (nonatomic, strong) LOTAnimationView *hbAnimationView;
@property (weak, nonatomic) IBOutlet UIView *cashWithdrawalView;
@property (weak, nonatomic) IBOutlet UILabel *cashWithdrawalTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *gameSubNumLabel;

@end

@implementation QCHomeViewController


- (QCGameHomeMusicViewModel *)indexViewModel {
    if (!_indexViewModel) {
        _indexViewModel = [[QCGameHomeMusicViewModel alloc] init];
    }
    return _indexViewModel;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self playerPlay];
    
    if (self.indexViewModel.answerIndexModel) {
        [self.xjView updateView];
        [self.hbView updateView];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self playerPause];
}

- (void)dealloc {
    [self.indexViewModel endTimer];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUi];
    
    [self loadData:0];
    
    NSInteger shareStatus = [QCUserModel getUserModel].recommend_config.status;
    if (shareStatus) {
        self.shareButton.hidden = NO;
    }
    
    [[QCAdManager sharedInstance] loadRewardVideoAd];
    [[QCAdManager sharedInstance] loadNativeAd];
    [[QCAdManager sharedInstance] loadSwitchAd];
}

- (void)setUi {
    
    self.hbPopupView.hidden = YES;
    self.wxPopupView.hidden = YES;
    self.wxPopupLabel.adjustsFontSizeToFitWidth = YES;
    
    NSAttributedString *att = [self.cashWithdrawalTimeLabel.text setStrokeColorHex:@"#1B9823"];
    self.cashWithdrawalTimeLabel.attributedText = att;
    
    [self.wxPopupView viewWaggleEnterAnimal];
    [self.hbPopupView viewWaggleEnterAnimal];
    
    __weak typeof(self) weakSelf = self;
    self.xjView.tapActionCallBack = ^{
        [weakSelf toXjWithdrawalController];
    };
    
    self.hbView.cashButtonCallBack = ^{
        [weakSelf toHbWithdrawalController];
    };
    
    QCUserModel *userModel = [QCUserModel getUserModel];
    [self configAssistantImageView:userModel.assistant_pic];
}


- (void)loadData:(NSInteger)skip {
    __weak typeof(self) weakSelf = self;
    [self.indexViewModel requestGameIndex:skip
                           onSuccess:^{
        
        [weakSelf configAnswerButtonTitleAndImageAt:0];
        [weakSelf configAnswerButtonTitleAndImageAt:1];
        
        [weakSelf configProgressViewUi];
        
        [weakSelf updateTopView];
        
        [weakSelf configHbPopView];
        
        
        if (weakSelf.indexViewModel.checkCollectShowNewUserController) {
            [weakSelf pushWithdrawalControllerNewUser:YES callBack:nil];
        }
        
        if (![self.indexViewModel canShowNewUserGuide]) {
            NSString *file = weakSelf.indexViewModel.answerIndexModel.question.file;
            [weakSelf playAudioWithURLString:file];
        }else {
            [weakSelf showNewUserGuideController];
        }
        
        if (weakSelf.indexViewModel.checkShowNewUserRelationsGuideToast) {
            [weakSelf showGuideControllerWithType:StartGuideTypeNext dismissCompletion:^{
                [weakSelf.indexViewModel showNewUserRelationsGuideToast];
            }];
        }
        
        if (weakSelf.indexViewModel.checkNewUser) {
            [weakSelf showAssistantToastController];
        }
        
        if (weakSelf.indexViewModel.answerIndexModel.user_info.guide_page_num == 4) {
            [weakSelf tabbrBottomViewUnlock];
        }
        
        //是否显示download任务入口  取反
        weakSelf.cashWithdrawalView.hidden = !weakSelf.indexViewModel.canShowCashWithdrawalView;
       
    } onError:^(NSInteger code, NSString * _Nonnull msg) {
        [weakSelf showReloadAlertMessage:msg doneButtonAction:^{
            [weakSelf loadData:skip];
        }];
    }];
}

- (void)configHbPopView {
    BOOL canTx = self.indexViewModel.answerIndexModel.hb_can_tx;
    self.hbPopupView.hidden = !canTx;
}

- (void)tabbrBottomViewUnlock {
    if (self.indexViewModel.answerIndexModel.user_info.guide_page_num == 4) {
        QCMainTabbarViewController *tabbarVc = (QCMainTabbarViewController *)self.tabBarController;
        [tabbarVc unLookTabbarItemGroupImage];
    }
}

- (void)configAnswerButtonTitleAndImageAt:(NSInteger)index {
    QCMusicOptionModel *optionModel = self.indexViewModel.answerIndexModel.question.option[index];
    NSString *title = optionModel.title;
    QCAnswerButton *button = index == 0 ? self.muiscOneButton : self.musicTwoButton;
    [self configAnswerButtont:button title:title];
}

- (void)configAnswerButtont:(QCAnswerButton *)button title:(NSString *)title {
    [button setTitle:title forState:UIControlStateNormal];
    [button resetButton];
}

- (void)configProgressViewUi {
    self.gameSubNumLabel.text = self.indexViewModel.subGameNumText;
    self.currentLevelNumLabel.attributedText = self.indexViewModel.progressViewGameStageAttributedString;
    self.currentLevelMoneyLabel.attributedText = self.indexViewModel.progressViewMoneyAttributedString;
    [self configProgressBarUiAtMax:NO];
}

- (void)configProgressBarUiAtMax:(BOOL)max {
    self.currentLevelProgressLabel.attributedText = [self.indexViewModel progressLabelAttributedStringAtMax:max];
    
    float progressValue = [self.indexViewModel progressValueAtMax:max];
    [self.levelProgressView setProgress:progressValue animated:YES];
}

- (void)configAssistantImageView:(NSString *)pic {
    [self.anchorImageView setImageWithURLString:pic];
}


- (void)updateTopView {
    self.wxPopupView.hidden = !self.indexViewModel.canShowCashOutPopView;
    self.hbPopupView.hidden = !self.indexViewModel.showHbCashPopView;
    self.wxPopupLabel.text = self.indexViewModel.cashOutPopText;
    
    [self.xjView updateView];
    [self.hbView updateView];
}

- (IBAction)shareAppButtonAction:(id)sender {
    QCSharePopupViewController *vc = [[QCSharePopupViewController alloc] init];
    [self presenClearColorPopupController:vc];
}

- (IBAction)freedBackButtonAction:(id)sender {
    QCCashFeedBackController *vc = [[QCCashFeedBackController alloc] init];
    [self pushViewController:vc];
}

- (IBAction)assistianButtonAction:(id)sender {
    [self playTouchButtonSound];
    QCAsisstionViewController *vc = [[QCAsisstionViewController alloc] init];
    __weak typeof(self) weakSelf = self;
    vc.clooseCallBack = ^(NSString * _Nonnull pic) {
        [weakSelf configAssistantImageView:pic];
    };
    [self pushViewController:vc];
}

- (IBAction)cashWithdrawalButtonAction:(id)sender {
    if (self.indexViewModel.canPushCashHb) {
        [self pushCashHbController];
    }else {
        [self showToast:@"冷却中"];
    }
}

- (IBAction)settingsButtonAction:(id)sender {
    [self playTouchButtonSound];
    QCSettingsViewController *vc = [[QCSettingsViewController alloc] init];
    [self presenClearColorPopupController:vc];
}

- (IBAction)musicOneButtonAction:(id)sender {
    [self selectMusicButton:self.muiscOneButton];
}

- (IBAction)musicTwoButtonAction:(id)sender {
    [self selectMusicButton:self.musicTwoButton];
}

- (void)selectMusicButton:(QCAnswerButton *)button {
    if (!self.indexViewModel.answerIndexModel) {
        return;
    }
    
    NSInteger index = button == self.muiscOneButton ? 0 : 1;
    BOOL right = [self.indexViewModel isCheckChooseQuestionRightAtIndex:index];
    if (right) {
        [self playXuanDui];
        [button answerRight];
        if (self.indexViewModel.checkNewUser) {
            if (self.indexViewModel.checkRelations) {
                [self collectNewUserGold];
                [self configProgressBarUiAtMax:YES];
            }else {
                [self loadData:1];
            }
        }else {
            if (self.indexViewModel.checkRelations) {
                [self configProgressBarUiAtMax:YES];
            }
            [self showRewardController:AQRewardTypeNormal];
        }
    }else {
        [self playXuanCuo];
        [button answerWrong];
        [self loadData:0];
    }
}

- (void)collectNewUserGold {
    [self showHUD];
    __weak typeof(self) weakSelf = self;
    [self.indexViewModel requestCollectNewUserGold:^{
        [weakSelf dismissHUD];
        [weakSelf updateTopView];
        [weakSelf showRewardController:AQRewardTypeNewUser];
    } onError:^(NSInteger code, NSString * _Nonnull msg) {
        if (code == SERVICE_REQUEST_ERROR_CODE) {
            [weakSelf dismissHUD];
            [weakSelf showReloadAlertMessage:msg doneButtonAction:^{
                [weakSelf collectNewUserGold];
            }];
        }else {
            [weakSelf showToast:msg];
        }
    }];
}

- (void)showRewardController:(AQRewardType)rewardType {
    QCRewardController *vc = [[QCRewardController alloc] init];
    vc.rewardType = rewardType;
    vc.indexViewModel = self.indexViewModel;
    __weak typeof(self) weakSelf = self;
    vc.autoDismiss = ^{
        [weakSelf loadData:1];
    };
    vc.dismissCompletion = ^{
        if (weakSelf.indexViewModel.checkNewUser) {
            [weakSelf pushWithdrawalControllerNewUser:YES callBack:^{
                [weakSelf showAssistantToastController];
                [weakSelf loadData:0];
            }];
        }else {
            [weakSelf loadData:0];
            QCRewardDetailController *detailVc = [[QCRewardDetailController alloc] init];
            detailVc.viewModel = weakSelf.indexViewModel;
            detailVc.dismissCompletion = ^{
                [weakSelf updateTopView];
                [weakSelf showGetMoneyAnimation];
                if (!weakSelf.indexViewModel.canShowWechatCashToast) {
                    if (weakSelf.indexViewModel.collectGoldType == QCCollectGoldTypeMax) {
                        [weakSelf showSettlementSwitchAd];
                    }
                }else {
                    if (weakSelf.indexViewModel.collectGoldType != QCCollectGoldTypeMin) {
                        [weakSelf showWechtPromptController];
                    }
                }
                
                [weakSelf showAssistantToastController];
            };
            [weakSelf presenClearColorPopupController:detailVc];
        }
    };
    [self presenClearColorPopupController:vc];
}

- (void)showWechtPromptController {
    QCWechatCashPromptController *vc = [[QCWechatCashPromptController alloc] init];
    __weak typeof(self) weakSelf = self;
    vc.dismissCompletion = ^{
        [weakSelf pushCashHbController];
    };
    [self presenClearColorPopupController:vc];
}

- (void)showAssistantToastController {
    if (self.indexViewModel.answerIndexModel.assistant_pop.pop) {
        QCUnLockNewStreamerController *vc = [[QCUnLockNewStreamerController alloc] init];
        __weak typeof(self) weakSelf = self;
        vc.popModel = self.indexViewModel.answerIndexModel.assistant_pop;
        vc.isNewUser = self.indexViewModel.checkNewUser;
        vc.callBack = ^(NSString * _Nonnull pic) {
            [weakSelf configAssistantImageView:pic];
        };
        [self presenClearColorPopupController:vc];
    }
}

- (void)pushCashHbController {
    QCCashWechatViewController *vc = [[QCCashWechatViewController alloc] init];
    __weak typeof(self) weaKSelf = self;
    vc.cashSuccessCallBack = ^{
        [weaKSelf.indexViewModel startTimerHandler:^(NSString * _Nonnull text) {
            [ThreadUtils onUiThreadCompletion:^{
                NSAttributedString *att = [text setStrokeColorHex:@"#1B9823"];
                weaKSelf.cashWithdrawalTimeLabel.attributedText = att;
            }];
        }];
    };
    [self pushViewController:vc];
}

- (void)pushWithdrawalControllerNewUser:(BOOL)newUser callBack:(WithrawalPopControllerCallBack)callBack {
    QCXJWithdrawalViewController *vc = [[QCXJWithdrawalViewController alloc] init];
    vc.popCallBack = callBack;
    vc.isNewUser = newUser;
    [self pushViewController:vc];
}

- (void)showNewUserGuideController {
    if ([self.indexViewModel canShowNewUserGuide]) {
        __weak typeof(self) weakSelf = self;
        [self showGuideControllerWithType:StartGuideTypeStart dismissCompletion:^{
            NSString *file = weakSelf.indexViewModel.answerIndexModel.question.file;
            [weakSelf playAudioWithURLString:file];
            QCGuideMaskView *maskView = [[QCGuideMaskView alloc] initWithFrame:[UIScreen mainScreen].bounds];
            NSInteger index = weakSelf.indexViewModel.getRightAnswerIndex;
            QCAnswerButton *button = index == 0 ? weakSelf.muiscOneButton : weakSelf.musicTwoButton;
            [maskView addHomeHollowOne:weakSelf.muiscOneButton.frame twoFrame:weakSelf.musicTwoButton.frame finger:index];
            maskView.touchFrameActionCallBack = ^{
                [weakSelf.indexViewModel setShowNewUserKey];
                [weakSelf selectMusicButton:button];
            };
            [maskView show];
        }];
    }
}


- (void)showGuideControllerWithType:(StartGuideType)type dismissCompletion:(DismissCompletion)dismissCompletion {
    QCStartGuideViewController *vc = [[QCStartGuideViewController alloc] init];
    vc.guideType = type;
    vc.dismissCompletion = dismissCompletion;
    [self presenClearColorPopupController:vc];
}


- (void)showGetMoneyAnimation {
    [self playJinBiDaoZhang];
    self.xjAnimationView = [self createWxAnimationView];
    __weak typeof(self) weakSelf = self;
    [self.xjAnimationView playWithCompletion:^(BOOL animationFinished) {
        if (animationFinished) {
            [weakSelf.xjAnimationView removeFromSuperview];
        }
    }];
    
    if (self.indexViewModel.collectGoldType != QCCollectGoldTypeMin) {
        self.hbAnimationView = [self createHbAnimationView];
        [self.hbAnimationView playWithCompletion:^(BOOL animationFinished) {
            if (animationFinished) {
                [weakSelf.hbAnimationView removeFromSuperview];
            }
        }];
    }
}


- (void)toHbWithdrawalController {
    [self playTouchButtonSound];
    if (self.indexViewModel.answerIndexModel) {
        if (self.indexViewModel.canShowHBGroupButton) {
            QCHBWithdrawalController *vc = [[QCHBWithdrawalController alloc] init];
            __weak typeof(self) weakSelf = self;
            vc.cashOutSuccess = ^{
                weakSelf.indexViewModel.answerIndexModel.hb_can_tx = 0;
            };
            vc.doCashHbCallBack = ^{
                [weakSelf pushCashHbController];
            };
            [self pushViewController:vc];
        }else {
            [self showToast:@"需要达到第2关才能解锁哦"];
        }
    }else {
        __weak typeof(self) weakSelf = self;
        [self showReloadAlertMessage:@"数据异常，请重试！" doneButtonAction:^{
            [weakSelf loadData:0];
        }];
    }
}

- (void)toXjWithdrawalController {
    [self playTouchButtonSound];
    if (self.indexViewModel.answerIndexModel) {
        if (self.indexViewModel.canShowHBGroupButton) {
            if ([QCAdManager sharedInstance].conditionModel.xjtx_page == 1) {
                [self pushWithdrawalControllerNewUser:NO callBack:nil];
            }else {
                QCXJWithrawalDetailViewController *vc = [[QCXJWithrawalDetailViewController alloc] init];
                [self pushViewController:vc];
            }
        }else {
            [self showToast:@"需要达到第2关才能解锁哦"];
        }
    }else {
        __weak typeof(self) weakSelf = self;
        [self showReloadAlertMessage:@"数据异常，请重试！" doneButtonAction:^{
            [weakSelf loadData:0];
        }];
    }
}


@end
