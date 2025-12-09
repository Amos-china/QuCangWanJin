#import "QCFeedBackViewController.h"
#import "QCPlaceholderTextView.h"

@interface QCFeedBackViewController ()

@property (weak, nonatomic) IBOutlet QCPlaceholderTextView *textView;

@end

@implementation QCFeedBackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (IBAction)backButtonAction:(id)sender {
    [self popViewController];
}


- (IBAction)submitButtonAction:(id)sender {
    NSString *text = self.textView.text;
    if (text.length == 0) {
        [self showToast:@"请输入您要反馈的内容"];
        return;
    }
    
    [self requestSubmit:text];
}

- (void)requestSubmit:(NSString *)text {
    __weak typeof(self) weakSelf = self;
    [self showHUD];
    [QCService requestWithType:MXEHttpRequestTypePost
                     urlString:@"https://wdtxios.apk5g.com/api/check_user/problemFeedback"
                    parameters:@{@"text":text}
                  successBlock:^(NSDictionary * _Nonnull responseObject) {
        [weakSelf dismissHUD];
        QCRootModel *rootModel = [QCRootModel modelWithkeyValues:responseObject];
        if (rootModel.code == 1) {
            [weakSelf showAlertControllerMessage:@"我们已经收到了您的反馈信息。" doneButtonAction:^{
                [weakSelf popViewController];
            } cancelButtonAction:^{
                [weakSelf popViewController];
            }];
        }
    } failureBlock:^(NSError * _Nonnull error) {
        [weakSelf showToast:error.localizedDescription];
    }];
}

@end
