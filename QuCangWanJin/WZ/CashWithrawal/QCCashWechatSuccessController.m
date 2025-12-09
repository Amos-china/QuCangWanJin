#import "QCCashWechatSuccessController.h"

@interface QCCashWechatSuccessController ()

@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UIButton *getButton;

@end

@implementation QCCashWechatSuccessController

- (instancetype)init {
    if (self = [super init]) {
        self.contentSizeInPopup = [UIImage imageNamed:@"popup_common_bg"].size;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.moneyLabel.text = SF(@"+%@元",self.moneyValue);
}

- (IBAction)getButtonAction:(id)sender {
    [self popupControllerDismissWithCompletion:self.dismissCompletion];
}

@end
