//
//  QCGameMainViewController.m
//  QuCangWanJin
//
//  Created by 陈志远 on 2025/11/25.
//

#import "QCGameEmojiViewController.h"
#import "QCGameMainViewController.h"
#import "QCGameIndexViewController.h"
#import "QCGameUserDataModel.h"
@interface QCGameMainViewController ()

@property (weak, nonatomic) IBOutlet UIButton *twoButton;

@end

@implementation QCGameMainViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    QCGameUserDataModel *dataModel = [QCGameUserDataModel getUserData];
    if (dataModel.musicGameUnlock) {
        [self.twoButton setBackgroundImage:IMG(@"gsb_tgsq_unlock_im") forState:UIControlStateNormal];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)oneButtonAction:(id)sender {
    QCGameEmojiViewController *vc = [[QCGameEmojiViewController alloc] init];
    [self pushViewController:vc];
}

- (IBAction)twoButtonAction:(id)sender {
    QCGameUserDataModel *dataModel = [QCGameUserDataModel getUserData];
    if (dataModel.musicGameUnlock) {
        QCGameIndexViewController *vc = [[QCGameIndexViewController alloc] init];
        [self pushViewController:vc];
    }else {
        [self showToast:@"请闯关完成看图猜歌才可以解锁"];
    }
}

- (IBAction)threeButtonAction:(id)sender {
    [self showToast:@"请闯关完成听歌识曲才可以解锁"];
}

- (IBAction)fourButtonAction:(id)sender {
    [self showToast:@"请闯关完成竞速识曲才可以解锁"];
}

- (void)makeTextToast {
    [self showToast:@"请完成看图猜歌名才可以解锁"];
}

@end
