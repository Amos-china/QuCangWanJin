#import "QCUnRegisterUserViewController.h"
#import "QCTextTableViewCell.h"
#import "QCSelectTextTableViewCell.h"
#import "QCLauncherController.h"

@interface QCUnRegisterUserViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<QCUnRegisterModel *> *datas;

@end

@implementation QCUnRegisterUserViewController

- (instancetype)init {
    if (self = [super init]) {
        CGSize size = [UIImage imageNamed:@"zxzh-bg"].size;
        size.height = size.height + 100.f;
        self.contentSizeInPopup = size;
    }
    return self;
}

- (NSMutableArray<QCUnRegisterModel *> *)datas {
    if (!_datas) {
        _datas = [NSMutableArray array];
    }
    return _datas;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createData];
    
    [self setUi];
}

- (void)createData {
    NSArray<NSString *> *dataStr = @[
        @"您自主发起注销账户申请，且账户正处于安全状态。",
        @"绑定的设备和微信账号无法再次注册和绑定“曲藏万金”。",
        @"您的帐户将永远停用，账号内所有相关数据将永久删除清空，且无法恢复。"
    ];
    
    for (NSString *value in dataStr) {
        QCUnRegisterModel *model = [[QCUnRegisterModel alloc] init];
        model.title = value;
        [self.datas addObject:model];
    }
}

- (void)setUi {
    NSArray<Class> *clss = @[QCTextTableViewCell.class,QCSelectTextTableViewCell.class];
    [self.tableView registerNibClasses:clss];
}

- (IBAction)closeButtonAction:(id)sender {
    [self.popupController popViewControllerAnimated:YES];
}

- (IBAction)unRegisterButtonAction:(id)sender {
    if ([self checkUnRegister]) {
        //请求
        [self requestUnregister];
    }else {
        [self showToast:@"请勾选全部条例"];
    }
}

- (void)requestUnregister {
    __weak typeof(self) weakSelf = self;
    [self showHUD];
    [self.viewModel requestUserCancellation:^{
        [ThreadUtils onUiThreadDelay:1.5 onCompletion:^{
            [weakSelf dismissHUD];
            [weakSelf showLauncherController];
        }];
    } onError:^(NSInteger code, NSString * _Nonnull msg) {
        [weakSelf showToast:msg];
    }];
}

- (void)showLauncherController {
    QCLauncherController *vc = [[QCLauncherController alloc] init];
    APPDELEGATE.window.rootViewController = vc;
    [APPDELEGATE.window makeKeyAndVisible];
}

- (BOOL)checkUnRegister {
    for (QCUnRegisterModel *model in self.datas) {
        if (!model.select) {
            return NO;
        }
    }
    return YES;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellName = @"";
    if (indexPath.section == 0) {
        cellName = NSStringFromClass(QCTextTableViewCell.class);
        QCTextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
        cell.textValue = SF(@"您的ID:%@账号将被删除，同时还有以下影响：",self.viewModel.userModel.user_info.user_id);
        return cell;
    }else {
        cellName = NSStringFromClass(QCSelectTextTableViewCell.class);
        QCSelectTextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
        cell.model = self.datas[indexPath.row];
        return cell;
    }
}

@end
