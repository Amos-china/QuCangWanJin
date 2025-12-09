#import "QCBaseViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface QCBaseViewController ()

@end

@implementation QCBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)updateAppUrl:(NSString *)downloadUrl {
    NSURL *url = [NSURL URLWithString:downloadUrl];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
    }
}

- (void)popViewController {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)pushViewController:(UIViewController *)viewController {
    viewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)showRewardAdAtCustomToast:(NSString *)toast
                            close:(CloseAdCompletionHandler)close
                            error:(QCHTTPRequestResponseErrorBlock)error {
    __weak typeof(self) weakSelf = self;
    [self showHUD];
    [[QCAdManager sharedInstance] requestHomeIndex:^(QCCommedHomeIndexModel * _Nonnull indexModel) {
        if (indexModel.user_info.status == 1) {
            if (!indexModel.ad_fj.sp_fj) {
                if (indexModel.ad_fj.video_is_max) {
                    [weakSelf showToast:indexModel.ad_fj.ad_fj_ts];
                }else {
                    BOOL show = [[QCAdManager sharedInstance] showRewardVideoAdWithController:weakSelf
                                                                            completionHandler:close];
                    if (!show) {
                        [weakSelf showToast:@"暂无视频,请稍后再试"];
                    }else {
                        [weakSelf dismissHUD];
                        [ThreadUtils onUiThreadDelay:1 onCompletion:^{
                            [weakSelf showCustomToast:toast];
                        }];
                    }
                }
            }else {
                [weakSelf showToast:indexModel.ad_fj.ad_fj_ts];
            }
        } else {
            [weakSelf dismissHUD];
            NSString *text = @"账号异常,限制登录";
            [weakSelf showExitApplicationAlertMsg:text];
        }
    } error:^(NSInteger code, NSString * _Nonnull msg) {
        [weakSelf showToast:msg];
    }];
}

- (LOTAnimationView *)createAnimationViewAt:(NSString *)name {
    LOTAnimationView *animationView = [LOTAnimationView animationNamed:name];
    animationView.frame = self.view.frame;
    animationView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:animationView];
    return animationView;
}

- (LOTAnimationView *)createWxAnimationView {
    return [self createAnimationViewAt:@"add_wx_money"];
}

- (LOTAnimationView *)createHbAnimationView {
    return [self createAnimationViewAt:@"add_hb_money"];
}

@end
