#import "QCStartGuideViewController.h"

@interface QCStartGuideViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *gifImageView;
@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;

@end

@implementation QCStartGuideViewController

- (instancetype)init {
    if (self = [super init]) {
        self.contentSizeInPopup = CGSizeMake(KWidth, KHeight);
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self playKaiShiHengfu];
    
    if (self.guideType == StartGuideTypeNext) {
        [self playTongGuanQuanBuTiXian];
        self.startButton.hidden = YES;
        self.gifImageView.hidden = YES;
        self.bgImageView.image = [UIImage imageNamed:@"guide-bg4"];
        __weak typeof(self) weakSelf = self;
        [ThreadUtils onUiThreadDelay:1.5 onCompletion:^{
            [weakSelf popupControllerDismissWithCompletion:weakSelf.dismissCompletion];
        }];
    }else {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"yindao_shouzhi" ofType:@"gif"];
        NSData *data = [NSData dataWithContentsOfFile:path];
        UIImage *image = [UIImage sd_imageWithGIFData:data];
        self.gifImageView.image = image;
    }
    
    [self.startButton beginEnlargeAnimation];
}

- (IBAction)startButtonAction:(id)sender {
    [self playTouchButtonSound];
    [self popupControllerDismissWithCompletion:self.dismissCompletion];
}

@end
