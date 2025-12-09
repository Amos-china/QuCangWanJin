#import "QCUnLockNewStreamerController.h"
#import "QCAssistantViewModel.h"

@interface QCUnLockNewStreamerController ()

@property (weak, nonatomic) IBOutlet UIImageView *iconIM;
@property (weak, nonatomic) IBOutlet UIImageView *iconBgIM;
@property (nonatomic, strong) QCAssistantViewModel *viewModel;
@property (weak, nonatomic) IBOutlet UIImageView *viewBgIM;
@property (weak, nonatomic) IBOutlet UIStackView *buttonStackView;
@property (weak, nonatomic) IBOutlet UIImageView *titleBgIM;

@end

@implementation QCUnLockNewStreamerController

- (QCAssistantViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[QCAssistantViewModel alloc] init];
    }
    return _viewModel;
}

- (instancetype)init {
    if (self = [super init]) {
        self.contentSizeInPopup = [UIScreen mainScreen].bounds.size;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self playXiaoZhuLiGengHuan];
    
    [self.iconBgIM viewNonstopRotationAnimation];
    
    ViewRadius(self.iconIM, HEIGHT(80.f));
    
    [self.iconIM setImageWithURLString:self.popModel.pic_thumb];
    
    [self playMeiNvLaiLe];
    
    if (self.isNewUser) {
        self.titleBgIM.hidden = YES;
        self.buttonStackView.hidden = YES;
        self.viewBgIM.image = [UIImage imageNamed:@"guide-unlock-bg"];
        
        [self autoDismiss];
    }
}

- (void)autoDismiss {
    __weak typeof(self) weakSelf = self;
    [ThreadUtils onUiThreadDelay:2 onCompletion:^{
        [weakSelf.viewModel requestChooseAssistant:weakSelf.popModel.assisTant_id onSuccess:^{
            !weakSelf.callBack? :weakSelf.callBack(weakSelf.viewModel.chooseAssistantModel.assistant_pic);
            [weakSelf popupControllerDismiss];
        } onError:^(NSInteger code, NSString * _Nonnull msg) {
            [weakSelf showReloadAlertMessage:msg doneButtonAction:^{
                [weakSelf autoDismiss];
            }];
        }];
    }];
}

- (IBAction)laterButtonAction:(id)sender {
    [self playTouchButtonSound];
    [self popupControllerDismiss];
}

- (IBAction)startButtonAction:(id)sender {
    [self playTouchButtonSound];
    __weak typeof(self) weakSelf = self;
    [self showHUD];
    [self.viewModel requestChooseAssistant:self.popModel.assisTant_id onSuccess:^{
        [weakSelf dismissHUD];
        !weakSelf.callBack? :weakSelf.callBack(weakSelf.viewModel.chooseAssistantModel.assistant_pic);
        [weakSelf popupControllerDismiss];
    } onError:^(NSInteger code, NSString * _Nonnull msg) {
        [weakSelf showToast:msg];
    }];
}

@end
