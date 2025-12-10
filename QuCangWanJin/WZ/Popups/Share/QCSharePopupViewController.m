//
//  QCSharePopupViewController.m
//  QuCangWanJin
//
//  Created by 陈志远 on 2025/12/10.
//

#import "QCSharePopupViewController.h"

@interface QCSharePopupViewController ()

@property (weak, nonatomic) IBOutlet UILabel *urlLabel;

@end

@implementation QCSharePopupViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.contentSizeInPopup = IMG(@"fxhy_bg_im").size;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *link = [QCUserModel getUserModel].recommend_config.link;
    self.urlLabel.text = link;
}

- (IBAction)closeButtonAction:(id)sender {
    [self popupControllerDismiss];
}

- (IBAction)copyButtonAction:(UIButton *)sender {
    [UIPasteboard generalPasteboard].string = self.urlLabel.text;
    [self showToast:@"链接已复制到剪切板"];
}


@end
