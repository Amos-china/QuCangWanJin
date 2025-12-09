#import "QCGameIndexViewController.h"
#import "QCGameIndexPopupViewController.h"
#import "QCGameIndexViewModel.h"
#import "QCGameIndexViewController+Audio.h"
@interface QCGameIndexViewController ()

@property (weak, nonatomic) IBOutlet UIView *pointsView;
@property (weak, nonatomic) IBOutlet UILabel *pointsLabel;
@property (weak, nonatomic) IBOutlet UILabel *levelLabel;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIButton *oneButton;
@property (weak, nonatomic) IBOutlet UIButton *twoButton;
@property (weak, nonatomic) IBOutlet UIButton *threeButton;
@property (weak, nonatomic) IBOutlet UIButton *fourButton;
@property (nonatomic, strong) QCGameIndexViewModel *viewModel;

@property (nonatomic, copy) NSArray<UIButton *> *optionButtons;

@end

@implementation QCGameIndexViewController


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.pointsLabel.text = self.viewModel.getCurrentPoints;
    self.levelLabel.text = self.viewModel.controllerLevelTitle;
    
    [self playerPlay];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self playerPause];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    CGFloat height = (IMG(@"gsb_game_top_ej").size.height + 8.f) / 2;
    ViewRadius(self.pointsView, height);
    
    
    [[QCAdManager sharedInstance] loadRewardVideoAd];
    
    self.viewModel = [[QCGameIndexViewModel alloc] init];
    
    self.optionButtons = @[
        self.oneButton,
        self.twoButton,
        self.threeButton,
        self.fourButton
    ];
    
    [self resetButtons];
    
    self.pointsLabel.text = self.viewModel.getCurrentPoints;
    self.levelLabel.text = self.viewModel.controllerLevelTitle;
    
    [self createSession];
    
    [self playAudioWithURLString:self.viewModel.getCurrentLevelGameMusicModel.url];
}

- (void)resetButtons {
    for (int i = 0; i < self.optionButtons.count; i ++) {
        UIButton *button = self.optionButtons[i];
        NSString *buttonTitle = [self.viewModel buttonTitleAtIndex:i];
        [button setTitle:buttonTitle forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor whiteColor]];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
}

- (IBAction)oneButtonAction:(UIButton *)sender {
    [self clossedButtonAtindex:0];
}

- (IBAction)twoButtonAction:(UIButton *)sender {
    [self clossedButtonAtindex:1];
}

- (IBAction)threeButtonAction:(UIButton *)sender {
    [self clossedButtonAtindex:2];
}

- (IBAction)fourButtonAction:(UIButton *)sender {
    [self clossedButtonAtindex:3];
}

- (void)clossedButtonAtindex:(NSInteger)index {
//    BOOL isRight = [self.viewModel checkOptionIsRightAtIndex:index];
//    NSString *colorHex = isRight ? @"#2DC92B" : @"#FF5950";
//    UIColor *buttonColor = [UIColor colorWithHexString:colorHex];
    
    self.viewModel.selectIndex = index;
    
    [self resetButtons];
    
    UIButton *button = self.optionButtons[index];
//    [button setBackgroundColor:buttonColor];
//    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [button setBackgroundColor:[UIColor colorWithHexString:@"#2DC92B"]];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

- (IBAction)backButtonAction:(id)sender {
    [self popViewController];
}

- (IBAction)submitButtonActio:(id)sender {
    BOOL isRight = [self.viewModel checkOptionIsRight];
    [self.viewModel changePointsWithRight:isRight];
    GameIndexPopupType popupType = isRight ? GameIndexPopupTypeSuccess : GameIndexPopupTypeError;
    [self showGameIndexPopupController:popupType];
}

- (IBAction)resetButtonAction:(id)sender {
    __weak typeof(self) weakSelf = self;
    [self showRewardVideoMsg:@"本关不可以重选" completionHandler:^(QCAdEcpmInfoModel * _Nonnull ecpmInfoModel) {
        [weakSelf resetButtons];
        [weakSelf.viewModel reset];
    }];
}

- (IBAction)iderButtonAction:(id)sender {
    __weak typeof(self) weakSelf = self;
    [self showRewardVideoMsg:@"本关不可以没有提示" completionHandler:^(QCAdEcpmInfoModel * _Nonnull ecpmInfoModel) {
        [weakSelf resetButtons];
        NSInteger index = [weakSelf.viewModel ider];
        [weakSelf clossedButtonAtindex:index];
    }];
}

- (void)showRewardVideoMsg:(NSString *)msg completionHandler:(CloseAdCompletionHandler)completionHandler {
    __weak typeof(self) weakSelf = self;
    BOOL show = [[QCAdManager sharedInstance] showRewardVideoAdWithController:self completionHandler:^(QCAdEcpmInfoModel * _Nonnull ecpmInfoModel) {
        if (ecpmInfoModel.isGiveReward) {
            completionHandler(ecpmInfoModel);
        }else {
            [weakSelf showToast:@"观看整条视频才有效哦~"];
        }
        [weakSelf playerPlay];
    }];
    
    if (!show) {
        [self showToast:msg];
    }else {
        [self playerPause];
    }
}

- (void)showGameIndexPopupController:(GameIndexPopupType)popupType {
    QCGameIndexPopupViewController *popupVc = [[QCGameIndexPopupViewController alloc] init];
    popupVc.popupType = popupType;
    __weak typeof(self) weakSelf = self;
    popupVc.actionCallBack = ^(NSInteger index) {
        if (index == 1) {
            //重选
            [weakSelf resetButtons];
            [weakSelf.viewModel reset];
        }else {
            //下一关
            [weakSelf.viewModel nextLevel];
            [weakSelf resetButtons];
            [weakSelf playAudioWithURLString:weakSelf.viewModel.getCurrentLevelGameMusicModel.url];
            weakSelf.levelLabel.text = weakSelf.viewModel.controllerLevelTitle;
        }
    };
    [self presenClearColorPopupController:popupVc];
}

@end
