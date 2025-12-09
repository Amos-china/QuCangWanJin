#import "QCUserinfoGuideViewController.h"
#import "AQWebViewController.h"
@interface QCUserinfoGuideViewController ()

@property (weak, nonatomic) IBOutlet YYLabel *yylabel;

@end

@implementation QCUserinfoGuideViewController

- (instancetype)init {
    if (self = [super init]) {
        self.contentSizeInPopup = IMG(@"guide_grxxbhyd_bg").size;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 原始文本
    NSString *fullText = @"您可阅读《隐私政策》和《用户协议》以及《风险识别SDK隐私权政策》了解详情，如您同意，请点击“同意”允许我们调用相关权限。";
    
    // 创建 NSMutableAttributedString
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:fullText];
    
    // 设置全局字体和颜色
    attributedString.yy_font = APPFONT(13);
    attributedString.yy_color = [UIColor blackColor];
    
    __weak typeof(self) weakSelf = self;
    // 为《隐私政策》添加下划线和链接
    NSRange privacyRange = [fullText rangeOfString:@"《隐私政策》"];
    [attributedString yy_setTextHighlightRange:privacyRange
                                         color:[UIColor redColor]
                               backgroundColor:[UIColor clearColor]
                                     tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        NSString *privacy = @"http://zrd.yuekenet.com/privacy/qcwj_ysxy.html";
        [weakSelf showWebController:@"隐私政策" url:privacy];
    }];
    
    
    // 为《用户协议》添加下划线和链接
    NSRange userAgreementRange = [fullText rangeOfString:@"《用户协议》"];
    [attributedString yy_setTextHighlightRange:userAgreementRange
                                         color:[UIColor redColor]
                               backgroundColor:[UIColor clearColor]
                                     tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        NSString *userAgreement = @"http://zrd.yuekenet.com/privacy/qcwj_yhxy.html";
        [weakSelf showWebController:@"用户协议" url:userAgreement];
    }];
    
    NSRange sdkPrivacyRang = [fullText rangeOfString:@"《风险识别SDK隐私权政策》"];
    [attributedString yy_setTextHighlightRange:sdkPrivacyRang
                                         color:[UIColor redColor]
                               backgroundColor:[UIColor clearColor]
                                     tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        NSString *sdkAgreement = @"https://terms.aliyun.com/legal-agreement/terms/suit_bu1_ali_cloud/suit_bu1_ali_cloud202111120818_92724.html?spm=a2c4g.11186623.0.0.69d01fc7Mm2Awd";
        [weakSelf showWebController:@"风险识别SDK隐私权政策" url:sdkAgreement];
    }];
    
    self.yylabel.attributedText = attributedString;
    self.yylabel.numberOfLines = 0;
    
}


- (IBAction)exitButtonAction:(id)sender {
    exit(0);
}

- (IBAction)agentButtonAction:(id)sender {
    [self popupControllerDismissWithCompletion:self.dismissCompletion];
}

- (void)showWebController:(NSString *)title url:(NSString *)url {
    AQWebViewController *webController = [[AQWebViewController alloc] init];
    webController.titleText = title;
    webController.url = url;
    [self presentViewController:webController animated:YES completion:nil];
}



@end
