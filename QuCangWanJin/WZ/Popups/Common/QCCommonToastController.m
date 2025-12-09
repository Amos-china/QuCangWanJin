#import "QCCommonToastController.h"

@interface QCCommonToastController ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;


@end

@implementation QCCommonToastController

- (instancetype)init {
    if (self = [super init]) {
        UIImage *image = [UIImage imageNamed:@"common_popup_toast_bg"];
        self.contentSizeInPopup = image.size;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpUi];
}

- (void)setUpUi {
    NSString *titleValue = @"";
    NSString *buttonTitle = @"";
    if (self.toastType == CommonToastTypeHB) {
        titleValue = @"温馨提示";
        buttonTitle = @"继续赚钱";
        self.contentLabel.text = self.contentValue;
    }else if (self.toastType == CommonToastTypeLevel) {
        titleValue = @"等级不足";
        buttonTitle = @"继续闯关";
        self.contentLabel.text = self.contentValue;
    }else if (self.toastType == CommonToastTypeBalance) {
        titleValue = @"余额不足";
        buttonTitle = @"继续赚钱";
        self.contentLabel.text = self.contentValue;
    }else if (self.toastType == CommonToastTypeActivity) {
        titleValue = @"活跃度不足";
        buttonTitle = @"继续闯关";
        self.contentLabel.text = self.contentValue;
    }else if (self.toastType == CommonToastTypeSettingLevel) {
        self.closeButton.hidden = NO;
        titleValue = @"我的等级";
        buttonTitle = @"继续闯关升级";
        [self configLevelAtt];
    }else if (self.toastType == CommonToastTypeCashHB) {
        titleValue = @"温馨提示";
        self.contentLabel.text = @"需领取1次'现金红包'，完成后再提现";
        buttonTitle = @"去完成";
        self.closeButton.hidden = NO;
    }
    self.titleLabel.text = titleValue;
    [self.nextButton setTitle:buttonTitle forState:UIControlStateNormal];
}

- (void)configLevelAtt {
    NSString *levelString = SF(@"我的等级：%@级",self.myLevel);
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:levelString];
    string.yy_font = [UIFont fontWithName:@"Resource-Han-Rounded-CN-Bold" size: 16.f];
    string.yy_color = AppColor;
    [string yy_appendString:@"\n闯关越多，升级越快"];
    self.contentLabel.attributedText = string;
}

- (IBAction)nextButtonAction:(id)sender {
    [self playTouchButtonSound];
    [self popupControllerDismissWithCompletion:self.dismissCompletion];
}

- (IBAction)closeButtonAction:(id)sender {
    [self playTouchButtonSound];
    if (self.toastType == CommonToastTypeSettingLevel) {
        [self.popupController popViewControllerAnimated:YES];
    }else if (self.toastType == CommonToastTypeHB) {
        [self popupControllerDismiss];
    }else {
        [self popupControllerDismissWithCompletion:self.dismissCompletion];
    }
}

@end
