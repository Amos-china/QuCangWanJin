#import "QCCashOutSuccessController.h"
#import "QCCashOutNoticeView.h"
@interface QCCashOutSuccessController ()

@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *userIconImageView;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@end

@implementation QCCashOutSuccessController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.contentSizeInPopup = CGSizeMake(KWidth - 60.f, 360.f);
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self playTiXiaoChengGong];
    
    NSString *moneyText = SF(@"%@元",self.doCashLog.tx_money);
    
    self.amountLabel.attributedText = [moneyText setMoneyFontAttMoneySize:44.f yuanSize:22.f];
    
    QCUserModel *userModel = [QCUserModel getUserModel];
    
    self.userNameLabel.text = userModel.user_info.nickname;
    
    [self.userIconImageView setImageWithURLString:userModel.user_info.face];
}

- (IBAction)nextButtonAction:(id)sender {
    [self playTouchButtonSound];
    NSDictionary *userInfo = @{@"key":self.doCashLog.tx_money};
    NSNotification *notification = [NSNotification notificationWithName:k_SHOW_WX_NOTICE object:nil userInfo:userInfo];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    [self popupControllerDismissWithCompletion:self.dismissCompletion];
}

- (IBAction)closeButtonAction:(id)sender {
    [self playTouchButtonSound];
    [self popupControllerDismiss];
}


@end
