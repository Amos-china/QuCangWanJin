
#import "QCWechatCashPromptController.h"

@interface QCWechatCashPromptController ()

@property (weak, nonatomic) IBOutlet UIButton *acceptButton;
@property (nonatomic, strong) dispatch_source_t timer;
@property (nonatomic, assign) NSInteger maxTime;

@end

@implementation QCWechatCashPromptController

- (instancetype)init {
    if (self = [super init]) {
        self.contentSizeInPopup = [UIScreen mainScreen].bounds.size;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.acceptButton.titleLabel setStrokeColorHex:@"#D26000"];
    
    self.maxTime = 4;
    
    [self startTimer];
}

- (void)setupAcceptButtonTitle:(NSString *)title {
    [self.acceptButton setTitle:title forState:UIControlStateNormal];
    [self.acceptButton.titleLabel setStrokeColorHex:@"#D26000"];
}

- (void)startTimer {
    // 创建GCD定时器
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    // 设置定时器 (1秒触发一次)
    dispatch_source_set_timer(self.timer, dispatch_time(DISPATCH_TIME_NOW, 0), 1 * NSEC_PER_SEC, 0);
    
    // 设置定时器回调
    __weak typeof(self) weakSelf = self;
    dispatch_source_set_event_handler(self.timer, ^{
        weakSelf.maxTime --;
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf setupAcceptButtonTitle:SF(@"开心收下(%ld)",weakSelf.maxTime)];
            if (weakSelf.maxTime == 0) {
                [weakSelf acceptButtonAction:weakSelf.acceptButton];
            }
        });
    });
    
    // 启动定时器
    dispatch_resume(self.timer);
}

- (void)endTimer {
    if (self.timer) {
        dispatch_source_cancel(self.timer);
        self.timer = nil;
    }
}

- (IBAction)acceptButtonAction:(id)sender {
    [self endTimer];
    [self popupControllerDismissWithCompletion:self.dismissCompletion];
}

@end
