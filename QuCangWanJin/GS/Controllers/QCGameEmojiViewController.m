//
//  QCGameEmojiViewController.m
//  QuCangWanJin
//
//  Created by 陈志远 on 2025/12/12.
//

#import "QCGameEmojiViewController.h"
#import "QCGameEmojiViewModel.h"
#import "QCGameIndexPopupViewController.h"

@interface QCGameEmojiViewController ()

@property (weak, nonatomic) IBOutlet UIView *pointsView;
@property (weak, nonatomic) IBOutlet UILabel *pointsLabel;
@property (weak, nonatomic) IBOutlet UILabel *levelNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *emojiLabel;
@property (weak, nonatomic) IBOutlet UIButton *oneButton;
@property (weak, nonatomic) IBOutlet UIButton *twoButton;
@property (weak, nonatomic) IBOutlet UIButton *threeButton;
@property (weak, nonatomic) IBOutlet UIButton *fourButton;

@property (nonatomic, copy) NSArray<UIButton *> *answerButtons;
@property (nonatomic, strong) QCGameEmojiViewModel *viewModel;

@end

@implementation QCGameEmojiViewController

- (QCGameEmojiViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[QCGameEmojiViewModel alloc] init];
    }
    return _viewModel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGFloat height = (IMG(@"gsb_game_top_ej").size.height + 8.f) / 2;
    ViewRadius(self.pointsView, height);
    
    self.answerButtons = @[self.oneButton,self.twoButton,self.threeButton,self.fourButton];
    
    [self configSubViews];
}

- (void)configSubViews {
    self.pointsLabel.text = self.viewModel.getCurrentPoints;
    self.levelNumLabel.text = self.viewModel.controllerLevelTitle;
    self.emojiLabel.text = self.viewModel.emojiImage;
    
    [self configButtons];
}

- (void)configButtons {
    for (int i = 0; i < self.answerButtons.count; i++) {
        NSString *option = [self.viewModel buttonTitleAtIndex:i];
        UIButton *button = self.answerButtons[i];
        [button setTitle:option forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor whiteColor]];
    }
}

- (IBAction)oneButtonAction:(UIButton *)sender {
    [self selectButtonWithIndex:0];
}

- (IBAction)twoButtonAction:(UIButton *)sender {
    [self selectButtonWithIndex:1];
}

- (IBAction)threeButtonAction:(UIButton *)sender {
    [self selectButtonWithIndex:2];
}

- (IBAction)fourButtonAction:(UIButton *)sender {
    [self selectButtonWithIndex:3];
}

- (void)selectButtonWithIndex:(NSInteger)index {
    [self configButtons];
    self.viewModel.selectIndex = index;
    UIButton *button = self.answerButtons[index];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor colorWithHexString:@"#2DC92B"]];
}

- (IBAction)backButtonAction:(id)sender {
    [self popViewController];
}

- (IBAction)submitButtonAction:(id)sender {
    if (self.viewModel.selectIndex == -1) {
        [self showToast:@"请选择你的答案,再点击提交"];
        return;
    }
    BOOL isRight = [self.viewModel checkOptionIsRight];
    [self.viewModel changePointsWithRight:isRight];
    GameIndexPopupType popupType = isRight ? GameIndexPopupTypeSuccess : GameIndexPopupTypeError;
    [self showGameIndexPopupController:popupType];
}

- (IBAction)restButtonAction:(id)sender {
    __weak typeof(self) weakSelf = self;
    [self showRewardVideoMsg:@"本关不可以重选" completionHandler:^(QCAdEcpmInfoModel * _Nonnull ecpmInfoModel) {
        [weakSelf configButtons];
        [weakSelf.viewModel reset];
    }];
}

- (IBAction)iderButtonAction:(id)sender {
    __weak typeof(self) weakSelf = self;
    [self showRewardVideoMsg:@"本关不可以没有提示" completionHandler:^(QCAdEcpmInfoModel * _Nonnull ecpmInfoModel) {
        NSInteger index = [weakSelf.viewModel ider];
        [weakSelf selectButtonWithIndex:index];
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
    }];
    
    if (!show) {
        [self showToast:msg];
    }
}

- (void)showGameIndexPopupController:(GameIndexPopupType)popupType {
    QCGameIndexPopupViewController *popupVc = [[QCGameIndexPopupViewController alloc] init];
    popupVc.popupType = popupType;
    __weak typeof(self) weakSelf = self;
    popupVc.actionCallBack = ^(NSInteger index) {
        if (index == 1) {
            //重选
            [weakSelf configButtons];
            [weakSelf.viewModel reset];
        }else {
            //下一关
            [weakSelf.viewModel nextLevel];
            [weakSelf configSubViews];
            
        }
    };
    [self presenClearColorPopupController:popupVc];
}


@end
