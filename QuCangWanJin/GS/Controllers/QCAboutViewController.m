#import "QCAboutViewController.h"
#import "AppDeviceInfo.h"

@interface QCAboutViewController ()

@property (weak, nonatomic) IBOutlet UILabel *appVersionLabel;


@end

@implementation QCAboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    NSString *version = [AppDeviceInfo getCurrentAppVersion];
    
    self.appVersionLabel.text = SF(@"v%@",version);
    
}

- (IBAction)backButtonAction:(id)sender {
    [self popViewController]; 
}

@end
