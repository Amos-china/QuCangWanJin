//
//  AQXJWithrawalDetailViewController.m
//  AnswerQuestions
//
//  Created by 陈志远 on 2025/9/16.
//

#import "QCXJWithrawalDetailViewController.h"
#import "QCXJDetailStatusCell.h"
#import "QCXJDetailSubTileCell.h"
#import "QCTXLuckyController.h"
#import "QCCommonToastController.h"  
#import <UICountingLabel/UICountingLabel.h>

@interface QCXJWithrawalDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *cashOutButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *safeViewHeight;
@property (weak, nonatomic) IBOutlet UICountingLabel *canCashOutLabel;
@property (weak, nonatomic) IBOutlet UILabel *cashOutTimeLabel;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, assign) BOOL canTouchCashOutButton;

@end

@implementation QCXJWithrawalDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.canCashOutLabel.format = @"%.0f元";
    
    self.cashOutTimeLabel.text = [NSDate getCurrentTime];
    
    self.canCashOutLabel.method = UILabelCountingMethodLinear; // 线性变化
    
    if (!self.viewModel) {
        self.viewModel = [[QCCashOutViewModel alloc] init];
    }
    
    [self requestData];
    
    [self setUi];
    
}

- (void)requestData {
    [self showHUD];
    __weak typeof(self) weakSelf = self;
    [self.viewModel requestXjCashOutPage:^{
        [weakSelf dismissHUD];
        [weakSelf.viewModel createDetailArr];
        weakSelf.canCashOutLabel.text = weakSelf.viewModel.canCashMoneyText;
        [weakSelf configCashOutButtonTitle];
        [weakSelf.tableView reloadData];
        [weakSelf createTimer];
//        [weakSelf canShowLuckyController];
    } error:^(NSInteger code, NSString * _Nonnull msg) {
        [weakSelf dismissHUD];
        [weakSelf showReloadAlertMessage:msg doneButtonAction:^{
            [weakSelf requestData];
        }];
    }];
}

- (void)createTimer {
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(showNextSection) userInfo:nil repeats:YES];
}


- (void)showNextSection {
    if (self.currentIndex < self.viewModel.listModels.count) {
        
        QCXJDetailModel *detaiModel = self.viewModel.listModels[self.currentIndex];
        [self.viewModel.detailStatusArr addObject:detaiModel];
        
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:self.currentIndex];
        [self.tableView insertSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
        
        self.currentIndex ++;
    }else {
        [self.timer invalidate];
        self.timer = nil;
        self.canTouchCashOutButton = YES;
        [self canShowLuckyController];
    }
}

- (void)canShowLuckyController {
    //延迟2秒主动弹出
    if (self.viewModel.cashOutIndexModel.withdrawal.can_tx == 2) {
        __weak typeof(self) weakSelf = self;
        [ThreadUtils onUiThreadDelay:0.5 onCompletion:^{
            if (weakSelf.viewModel.cashOutIndexModel.withdrawal.can_tx == 2) {
                [weakSelf requestJiaYouBaoShowHud:NO];
            }
        }];
    }
}

- (void)configCashOutButtonTitle {
    BOOL isCashOut = self.viewModel.cashOutIndexModel.withdrawal.can_tx == 3;
    NSString *btnTitle = isCashOut ? @"提现" : @"确定";
    [self.cashOutButton setTitle:btnTitle forState:UIControlStateNormal];
}

- (void)requestJiaYouBaoShowHud:(BOOL)showHud {
    __weak typeof(self) weakSelf = self;
    if (showHud) {
        [self showHUD];
    }
    [self.viewModel requestJiaYouBaoSuccess:^{
        [weakSelf dismissHUD];
        [weakSelf showLuckyPopup];
        [weakSelf configCashOutButtonTitle];
    } error:^(NSInteger code, NSString * _Nonnull msg) {
        [weakSelf showToast:msg];
    }];
}

- (void)setUi {
    NSArray<Class> *clss = @[
        QCXJDetailSubTileCell.class,
        QCXJDetailStatusCell.class
    ];
    
    [self.tableView registerNibClasses:clss];
    
    self.safeViewHeight.constant = HOME_INDICATOR_HEIGHT;
}

- (IBAction)backButtonAction:(id)sender {
    [self popViewController];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.viewModel.detailStatusArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    QCXJDetailModel *model = self.viewModel.detailStatusArr[section];
    if (model.isShowDetail) {
        return 2;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QCXJDetailModel *model = self.viewModel.detailStatusArr[indexPath.section];
    if (indexPath.row == 0) {
        return [self titleCellAtModel:model];
    }else {
        return [self subTitleCellAtModel:model];
    }
}

- (QCXJDetailStatusCell *)titleCellAtModel:(QCXJDetailModel *)model {
    NSString *cellName = NSStringFromClass(QCXJDetailStatusCell.class);
    QCXJDetailStatusCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellName];
    cell.model = model;
    return cell;
}

- (QCXJDetailSubTileCell *)subTitleCellAtModel:(QCXJDetailModel *)model {
    NSString *cellName = NSStringFromClass(QCXJDetailSubTileCell.class);
    QCXJDetailSubTileCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellName];
    cell.model = model;
    return cell;
}

- (IBAction)cashOutButtonAction:(id)sender {
    if (!self.canTouchCashOutButton) {
        return;
    }
    
    if (self.viewModel.cashOutIndexModel.withdrawal.can_tx == 2) {
        [self requestJiaYouBaoShowHud:YES];
        return;
    }
    
    NSInteger type = self.viewModel.cashOutIndexModel.withdrawal.condition_type;
    QCXJDetailModel *detaiModel = nil;
    if (type == 1) {
        detaiModel = [self.viewModel clearanceConditions:NO];
        [self showToast:detaiModel.subTitle];
    }else if (type == 2) {
        //金额
        detaiModel = [self.viewModel moneyConditions:NO];
        [self showCommonToast:CommonToastTypeBalance text:detaiModel.toastText];
    }else if (type == 3) {
        //活跃
        detaiModel = [self.viewModel activiConditions:NO];
        [self showCommonToast:CommonToastTypeActivity text:detaiModel.toastText];
    }else if (type == 4) {
        //等级
        detaiModel = [self.viewModel levelConditions:NO];
        [self showCommonToast:CommonToastTypeLevel text:detaiModel.toastText];
    }else {
        [self showToast:@"未知"];
    }
}


- (void)showCommonToast:(CommonToastType)toastType text:(NSString *)text {
    QCCommonToastController *vc = [[QCCommonToastController alloc] init];
    vc.toastType = toastType;
    vc.contentValue = text;
    __weak typeof(self) weakSelf = self;
    vc.dismissCompletion = ^{
        [weakSelf.navigationController popToRootViewControllerAnimated:YES];
    };
    [self presenClearColorPopupController:vc];
}

- (void)showLuckyPopup {
    QCTXLuckyController *vc = [[QCTXLuckyController alloc] init];
    vc.viewModel = self.viewModel;
    __weak typeof(self) weakSelf = self;
    vc.dismissCompletion = ^{
        NSIndexPath *moneyIndexPath = [NSIndexPath indexPathForRow:1 inSection:4];
        [weakSelf.tableView reloadRowsAtIndexPaths:@[moneyIndexPath] withRowAnimation:UITableViewRowAnimationNone];
        [weakSelf playJinBiDaoZhang];
        [weakSelf updateMoneyLabel];
    };
    [self presenClearColorPopupController:vc];
}

- (void)updateMoneyLabel {
    CGFloat value = [self.viewModel.cashOutIndexModel.withdrawal.tx_money floatValue];
    [self.canCashOutLabel countFrom:0 to:value];
}

@end
