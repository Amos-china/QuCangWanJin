#import "QCTXLuckyController.h"
#import "UICountingLabel/UICountingLabel.h"

@interface QCTXLuckyController ()

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (weak, nonatomic) IBOutlet UICountingLabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UIButton *heppyButton;

@end

@implementation QCTXLuckyController

- (instancetype)init {
    if (self = [super init]) {
        CGSize size = [UIScreen mainScreen].bounds.size;
        self.contentSizeInPopup = size;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.moneyLabel.format = @"%.0f元";
    [self playXingYunJiaYouBao];
    CGFloat money = [self.viewModel.luckyModel.get_money floatValue];
    NSString *text = SF(@"%.2f元加油包助力光速到账，这波福利赶紧接住~",money);
    self.contentLabel.text = text;
    [self.moneyLabel countFrom:0.0 to:money];
    

    [self.heppyButton beginEnlargeAnimation];
    
}


- (IBAction)buttonAction:(id)sender {
    [self showHUD];
    __weak typeof(self) weakSelf = self;
    [self.viewModel requestXjCashOutPage:^{
        [weakSelf dismissHUD];
        [weakSelf.viewModel updateTableViewCell];
        [weakSelf popupControllerDismissWithCompletion:weakSelf.dismissCompletion];
    } error:^(NSInteger code, NSString * _Nonnull msg) {
        [weakSelf showToast:msg];
    }];
}


@end
