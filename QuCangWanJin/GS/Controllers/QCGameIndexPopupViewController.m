#import "QCGameIndexPopupViewController.h"

@interface QCGameIndexPopupViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *titleIM;
@property (weak, nonatomic) IBOutlet UIImageView *gxIM;
@property (weak, nonatomic) IBOutlet UIImageView *centerBgIM;
@property (weak, nonatomic) IBOutlet UILabel *pointsLabel;
@property (weak, nonatomic) IBOutlet UIImageView *statusIM;
@property (weak, nonatomic) IBOutlet UIButton *successNextButton;
@property (weak, nonatomic) IBOutlet UIButton *resetButton;
@property (weak, nonatomic) IBOutlet UIButton *errorNextButton;

@end

@implementation QCGameIndexPopupViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.contentSizeInPopup = [UIScreen mainScreen].bounds.size;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    if (self.popupType == GameIndexPopupTypeError) {
        self.titleIM.image = IMG(@"gsb_error_title_im");
        self.gxIM.hidden = YES;
        self.centerBgIM.hidden = YES;
        self.statusIM.image = IMG(@"gsb_error_kl_im");
        self.resetButton.hidden = NO;
        self.errorNextButton.hidden = NO;
        self.successNextButton.hidden = YES;
        self.pointsLabel.text = @"-10";
        self.pointsLabel.textColor = Color999;
    }else {
        [self.gxIM viewNonstopRotationAnimation];
    }
}


- (IBAction)successNextButtonAction:(id)sender {
    [self buttonAction:0];
}

- (IBAction)resetButtonAction:(id)sender {
    [self buttonAction:1];
}

- (IBAction)errorNextButtonAction:(id)sender {
    [self buttonAction:2];
}

- (void)buttonAction:(NSInteger)index {
    [self popupControllerDismissWithCompletion:^{
        !self.actionCallBack? : self.actionCallBack(index);
    }];
}

@end
