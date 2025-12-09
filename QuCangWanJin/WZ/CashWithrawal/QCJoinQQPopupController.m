#import "QCJoinQQPopupController.h"

@interface QCJoinQQPopupController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation QCJoinQQPopupController


- (instancetype)init {
    if (self = [super init]) {
        UIImage *image = [UIImage imageNamed:@"toast_ts_bg"];
        self.contentSizeInPopup = CGSizeMake(image.size.width, image.size.height + 50.f);
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.titleLabel setStrokeColorHex:@"#094FA7"];
}


- (IBAction)clooseButtonAction:(id)sender {
    [self popupControllerDismiss];
}

- (IBAction)joinQQButtonAction:(id)sender {
    [self popupControllerDismissWithCompletion:self.dismissCompletion];
}

@end
