//
//  UIViewController+HUD.m
//  MelonTheater
//
//  Created by 陈志远 on 2023/12/21.
//

#import "UIViewController+HUD.h"
#import <SVProgressHUD/SVProgressHUD.h>
@implementation UIViewController (HUD)

- (void)showToast:(NSString *)text {
    [SVProgressHUD showImage:[UIImage imageNamed:@""] status:text];
    [SVProgressHUD setFont:APPFONT(16.f)];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeFlat];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD dismissWithDelay:1.5];
}

- (void)showCustomToast:(NSString *)text {
    [SVProgressHUD showImage:[UIImage imageNamed:@""] status:text];
    [SVProgressHUD setFont:APPFONT(22.f)];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.6]];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeFlat];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleCustom];
    [SVProgressHUD dismissWithDelay:3];
}

- (void)showHUD {
    dispatch_async(dispatch_get_main_queue(), ^{
        [SVProgressHUD show];
        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    });
    
}

- (void)dismissHUD {
    dispatch_async(dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
    
}


@end
