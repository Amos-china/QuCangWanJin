#import "QCRealNameInfoController.h"

@interface QCRealNameInfoController ()

@property (weak, nonatomic) IBOutlet UILabel *despLabel;
@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UITextField *idCardTF;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumTF;


@end

@implementation QCRealNameInfoController

- (instancetype)init {
    if (self = [super init]) {
        CGSize size = [UIImage imageNamed:@"bcsmzxx-bg"].size;
        self.contentSizeInPopup = size;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *text = SF(@"    为了遵守国家相关规定，同时为了保护您的资金安全，我们需要获取您的实名认证信息，此实名认证信息仅用于微信提现，不会用于其他用途更不会泄露。\n   您碰到任何问题，请添加客服QQ：%@，我们会及时帮你解决。实名认证顺利完成，大额提现才可以顺利到账。",@"728972977");
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:text];
    [att yy_setColor:[UIColor colorWithHexString:@"#666666"] range:NSMakeRange(0, text.length)];
    
    NSRange range1 = [text rangeOfString:@"我们需要获取您的实名认证信息"];
    [att yy_setColor:[UIColor colorWithHexString:@"#FE2E96"] range:range1];
    
    NSRange range2 = [text rangeOfString:@"728972977"];
    [att yy_setColor:[UIColor colorWithHexString:@"#FE2E96"] range:range2];
    
    self.despLabel.attributedText = att;
}

- (IBAction)closeButtonAction:(id)sender {
    [self popupControllerDismiss];
}

- (IBAction)doneButtonAction:(id)sender {
    NSString *name = self.nameTF.text;
    NSString *idCard = self.idCardTF.text;
    NSString *phoneNum = self.phoneNumTF.text;
    
    if (name.length == 0) {
        [self showToast:@"请输入姓名"];
        return;
    }
    
    if (idCard.length == 0) {
        [self showToast:@"请输入身份证号码"];
        return;
    }
    
    if (phoneNum.length == 0) {
        [self showToast:@"请输入手机号"];
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    [self showHUD];
    [self.viewModel requestRealName:phoneNum name:name idCard:idCard success:^{
        [weakSelf showToast:@"认证成功"];
        [weakSelf popupControllerDismiss];
    } error:^(NSInteger code, NSString * _Nonnull msg) {
        [weakSelf showToast:msg];
    }];
}

@end
