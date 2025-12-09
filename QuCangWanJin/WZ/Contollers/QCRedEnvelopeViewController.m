

#import "QCRedEnvelopeViewController.h"
#import "QCHBWithdrawalController.h"
#import "QCXJWithdrawalViewController.h"
#import "QCGroupHBItemCell.h"
#import "QCGroupMessageItemCell.h"
#import "QCMeMessageItemCell.h"
#import "QCRedEnvelopeViewModel.h"
#import "QCHBGroupToastViewController.h"
#import "QCGroupMsgAdCell.h"
#import "QCHomeTopXJView.h"
#import "QCHomeTopHBView.h"

@interface QCRedEnvelopeViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet QCHomeTopXJView *xjView;
@property (weak, nonatomic) IBOutlet QCHomeTopHBView *hbView;

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (nonatomic, strong) QCRedEnvelopeViewModel *viewModel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;
@property (nonatomic, strong) LOTAnimationView *hbAnimationView;

@end

@implementation QCRedEnvelopeViewController{
    dispatch_source_t _timer;
    BOOL _timerRunning;
}

- (QCRedEnvelopeViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[QCRedEnvelopeViewModel alloc] init];
    }
    return _viewModel;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.viewModel.isCanSend = YES;
    
    [self.xjView updateView];
    [self.hbView updateView];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.viewModel.isCanSend = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configTableView];
    
    [self getData];
    
    __weak typeof(self) weakSelf = self;
    self.hbView.cashButtonCallBack = ^{
        if ([QCAdManager sharedInstance].conditionModel.xjtx_page == 1) {
            QCHBWithdrawalController *vc = [[QCHBWithdrawalController alloc] init];
            [weakSelf pushViewController:vc];
        }else {
            QCXJWithrawalDetailViewController *vc = [[QCXJWithrawalDetailViewController alloc] init];
            [self pushViewController:vc];
        }
        
    };
    
    self.xjView.tapActionCallBack = ^{
        
        QCXJWithdrawalViewController *vc = [[QCXJWithdrawalViewController alloc] init];
        [weakSelf pushViewController:vc];
    };
}

- (void)getData {
    __weak typeof(self) weakSelf = self;
    [self.viewModel createData:^{
        [weakSelf.tableView reloadData];
        [weakSelf scrollToBottomAnimated:NO];
        [weakSelf startTimer];
    } error:^(NSInteger code, NSString * _Nonnull msg) {
        [weakSelf showToast:msg];
    }];
    
    [self.viewModel requestAotuSendData];
}

- (void)configTableView {
    NSArray<Class> *clses = @[QCGroupHBItemCell.class,
                              QCGroupMessageItemCell.class,
                              QCMeMessageItemCell.class,
                              QCGroupMsgAdCell.class];
    self.tableView.estimatedRowHeight = 100.f;
    [self.tableView registerNibClasses:clses];
}

- (IBAction)sendButtonAction:(id)sender {
    NSString *msg = self.textField.text;
    if (msg.length == 0) {
        [self showToast:@"请输入消息"];
        return;
    }
    BOOL send = [self.viewModel sendMsg:msg];
    if (send) {
        NSInteger row = self.viewModel.msgList.count - 1;
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
        [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        [self scrollToBottomAnimated:YES];
    }
}


- (void)scrollToBottomAnimated:(BOOL)animated {
    if (self.viewModel.msgList.count == 0) return;
    
    NSIndexPath *lastIndexPath = [NSIndexPath indexPathForRow:self.viewModel.msgList.count - 1 inSection:0];
    [self.tableView scrollToRowAtIndexPath:lastIndexPath
                          atScrollPosition:UITableViewScrollPositionBottom
                                  animated:animated];
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
    uint64_t interval = (uint64_t)(3.0 * NSEC_PER_SEC); // 5 秒间隔
    uint64_t leeway = (uint64_t)(0.1 * NSEC_PER_SEC);   // 允许误差 0.1 秒
    
    dispatch_source_set_timer(_timer,
                              dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), // 立即开始
                              interval,
                              leeway);
    
    // 设置定时器回调
    __weak typeof(self) weakSelf = self;
    dispatch_source_set_event_handler(_timer, ^{
        [weakSelf timerFired];
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
    __weak typeof(self) weakSelf = self;
    [ThreadUtils onUiThreadCompletion:^{
        BOOL send = [weakSelf.viewModel aotuSendMsgWithController:weakSelf];
        if (send) {
            NSInteger lastRow = weakSelf.viewModel.msgList.count - 2;
            
            UITableViewCell *cell = weakSelf.tableView.visibleCells.lastObject;
            NSIndexPath *lastCellIndexPath = [weakSelf.tableView indexPathForCell:cell];
            
            NSInteger row = weakSelf.viewModel.msgList.count - 1;
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
            [weakSelf.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationBottom];
            
            if (lastCellIndexPath.row == lastRow) {
                [weakSelf scrollToBottomAnimated:YES];
            }
        }
    }];

}

- (void)dealloc {
    [self stopTimer];
    NSLog(@"释放了吗");
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.msgList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QCGroupMessageModel *msgModel = self.viewModel.msgList[indexPath.row];
    if (msgModel.type == 0) {
        return [self msgCellAtIndexPath:indexPath msgModel:msgModel];
    }else if (msgModel.type == 1) {
        return [self meMsgCellAtIndexPath:indexPath msgModel:msgModel];
    }else if (msgModel.type == 2) {
        return [self hbCellAtIndexPath:indexPath msgModel:msgModel];
    }else {
        return [self adMsgCellAtIndexPath:indexPath msgModel:msgModel];
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100.f;
}

- (QCGroupHBItemCell *)hbCellAtIndexPath:(NSIndexPath *)indexPath msgModel:(QCGroupMessageModel *)msgModel {
    NSString *cellName = NSStringFromClass(QCGroupHBItemCell.class);
    QCGroupHBItemCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellName];
    cell.msgModel = msgModel;
    __weak typeof(self) weakSelf = self;
    cell.buttonActionCallBack = ^(QCGroupMessageModel * _Nonnull model) {
        weakSelf.viewModel.selectIndexPath = indexPath;
        QCHBGroupToastViewController *vc = [[QCHBGroupToastViewController alloc] init];
        vc.viewModel = weakSelf.viewModel;
        vc.dismissCompletion = ^{
            [weakSelf.tableView reloadRowsAtIndexPaths:@[weakSelf.viewModel.selectIndexPath] withRowAnimation:UITableViewRowAnimationNone];
            [weakSelf createAnimationView];
        };
        [weakSelf presenClearColorPopupController:vc];
    };
    return cell;
}

- (void)createAnimationView {
    [self playJinBiDaoZhang];
    self.hbAnimationView = [self createHbAnimationView];
    __weak typeof(self) weakSelf = self;
    [self.hbAnimationView playWithCompletion:^(BOOL animationFinished) {
        if (animationFinished) {
            [weakSelf.hbAnimationView removeFromSuperview];
        }
    }];
}

- (QCGroupMessageItemCell *)msgCellAtIndexPath:(NSIndexPath *)indexPath msgModel:(QCGroupMessageModel *)msgModel {
    NSString *cellName = NSStringFromClass(QCGroupMessageItemCell.class);
    QCGroupMessageItemCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellName];
    cell.msgModel = msgModel;
    return cell;
}

- (QCMeMessageItemCell *)meMsgCellAtIndexPath:(NSIndexPath *)indexPath msgModel:(QCGroupMessageModel *)msgModel {
    NSString *cellName = NSStringFromClass(QCMeMessageItemCell.class);
    QCMeMessageItemCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellName];
    cell.msgModel = msgModel;
    return cell;
}

- (QCGroupMsgAdCell *)adMsgCellAtIndexPath:(NSIndexPath *)indexPath msgModel:(QCGroupMessageModel *)msgModel {
    NSString *cellName = NSStringFromClass(QCGroupMsgAdCell.class);
    QCGroupMsgAdCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellName];
    cell.msgModel = msgModel;
    return cell;
}

@end
