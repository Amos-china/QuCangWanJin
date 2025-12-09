#import "QCRewardDetailController.h"

@interface QCRewardDetailController ()

@property (weak, nonatomic) IBOutlet UILabel *xjMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *hbMoneyLabel;
@property (weak, nonatomic) IBOutlet UIView *hbView;
@property (weak, nonatomic) IBOutlet UIView *showAdView;
@property (weak, nonatomic) IBOutlet UILabel *userIdLabel;

@end

@implementation QCRewardDetailController

- (instancetype)init {
    if (self = [super init]) {
        self.contentSizeInPopup = [UIScreen mainScreen].bounds.size;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    QCUserInfoModel *userInfo = [QCUserModel getUserModel].user_info;
    self.userIdLabel.text = SF(@"ID:%@",userInfo.user_id);
    
    if (self.viewModel.collectGoldType == QCCollectGoldTypeMin) {
        self.hbView.hidden = YES;
    }else {
        self.hbMoneyLabel.text = SF(@"%@元",self.viewModel.collectGoldModel.get_gold_money);
    }
    
    self.xjMoneyLabel.text = SF(@"%@元",self.viewModel.collectGoldModel.get_hbq_money);
    
    __weak typeof(self) weakSelf = self;
    [ThreadUtils onUiThreadDelay:1.5 onCompletion:^{
        [weakSelf popupControllerDismissWithCompletion:weakSelf.dismissCompletion];
    }];
    
//    BUMCanvasView *adView = [[AQAdManager sharedInstance] getNativeADViewWithController:weakSelf];
//    if (adView) {
//        [self.showAdView addSubview:adView];
//        [adView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.right.left.bottom.mas_equalTo(0);
//        }];
//    }
}


@end
