//
//  AQWithdrawalHistoryController.m
//  AnswerQuestions
//
//  Created by 陈志远 on 2025/9/15.
//

#import "QCWithdrawalHistoryController.h"
#import "QCWithdrawalHistoryCell.h"
#import "QCCashOutHistoryViewModel.h"
@interface QCWithdrawalHistoryController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *emptyView;
@property (nonatomic, strong) QCCashOutHistoryViewModel *viewModel;

@end

@implementation QCWithdrawalHistoryController

- (QCCashOutHistoryViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[QCCashOutHistoryViewModel alloc] init];
    }
    return _viewModel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.rowHeight = 102.f;
    
    
    [self.tableView registerNibClasses:@[QCWithdrawalHistoryCell.class]];
    
    [self getData];
    
}

- (void)getData {
    __weak typeof(self) weakSelf = self;
    [self showHUD];
    [self.viewModel requestCashLog:^{
        [weakSelf dismissHUD];
        weakSelf.emptyView.hidden = weakSelf.viewModel.logModels.count;
        if (weakSelf.viewModel.logModels.count) {
            [weakSelf.tableView reloadData];
        }
    } error:^(NSInteger code, NSString * _Nonnull msg) {
        if (code == SERVICE_REQUEST_ERROR_CODE) {
            [weakSelf dismissHUD];
            [weakSelf showReloadAlertMessage:msg doneButtonAction:^{
                [weakSelf getData];
            }];
        }
        [weakSelf showToast:msg];
    }];
}

- (IBAction)backButtonAction:(id)sender {
    [self popViewController];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.logModels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellName = NSStringFromClass(QCWithdrawalHistoryCell.class);
    QCWithdrawalHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    cell.logModel = self.viewModel.logModels[indexPath.row];
    return cell;
}

@end
