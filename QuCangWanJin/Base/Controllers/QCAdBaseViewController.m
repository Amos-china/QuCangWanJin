#import "QCAdBaseViewController.h"

@interface QCAdBaseViewController ()

@end

@implementation QCAdBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    QCUserInfoModel *userInfo = [QCUserModel getUserModel].user_info;
    if (userInfo.guide_page_num == 4) {
        [self changedControllerShowSwitchAd];
    }
}

@end
