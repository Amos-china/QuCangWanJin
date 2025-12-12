//
//  QCGameMineViewController.m
//  QuCangWanJin
//
//  Created by 陈志远 on 2025/11/25.
//

#import "QCGameMineViewController.h"
#import "AQWebViewController.h"
#import "QCAboutViewController.h"
#import "QCFeedBackViewController.h"
#import "QCGameIndexViewModel.h"
#import "QCGameUserDataModel.h"
@interface QCGameMineViewController ()

@property (weak, nonatomic) IBOutlet UILabel *levelNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *musicLevelLabel;

@end

@implementation QCGameMineViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    QCGameUserDataModel *userData = [QCGameUserDataModel getUserData];
    
    self.levelNumLabel.text = SF(@"第%ld关",userData.emojiLevelNum + 1);
    
    if (userData.musicGameUnlock) {
        self.musicLevelLabel.text = SF(@"第%ld关",userData.musicLevelNum + 1);
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];

    
    
}

- (IBAction)userAgreementAction:(id)sender {
    [self toWebController:@"用户协议" url:@"http://zrd.yuekenet.com/privacy/qcwj_yhxy.html"];
}

- (IBAction)privacyPolicyAction:(id)sender {
    [self toWebController:@"隐私政策" url:@"http://zrd.yuekenet.com/privacy/qcwj_ysxy.html"];
}

- (IBAction)aboutUsAction:(id)sender {
    QCAboutViewController *vc = [[QCAboutViewController alloc] init];
    [self pushViewController:vc];
}

- (IBAction)freedQuestionsButton:(id)sender {
    QCFeedBackViewController *vc = [[QCFeedBackViewController alloc] init];
    [self pushViewController:vc];
}

- (void)toWebController:(NSString *)titleText url:(NSString *)url {
    AQWebViewController *vc = [[AQWebViewController alloc] init];
    vc.titleText = titleText;
    vc.url = url;
    [self pushViewController:vc];
}


@end
