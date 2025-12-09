//
//  QCGameMainViewController.m
//  QuCangWanJin
//
//  Created by 陈志远 on 2025/11/25.
//

#import "QCGameMainViewController.h"
#import "QCGameIndexViewController.h"
@interface QCGameMainViewController ()

@end

@implementation QCGameMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    
    
}

- (IBAction)oneButtonAction:(id)sender {
    QCGameIndexViewController *vc = [[QCGameIndexViewController alloc] init];
    [self pushViewController:vc];
}

- (IBAction)twoButtonAction:(id)sender {
    [self makeTextToast];
}

- (IBAction)threeButtonAction:(id)sender {
    [self makeTextToast];
}

- (IBAction)fourButtonAction:(id)sender {
    [self makeTextToast];
}

- (void)makeTextToast {
    [self showToast:@"请完成看图猜歌名才可以解锁"];
}

@end
