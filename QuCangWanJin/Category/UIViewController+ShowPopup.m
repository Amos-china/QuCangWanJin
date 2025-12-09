//
//  UIViewController+ShowPopup.m
//  MelonTheater
//
//  Created by 陈志远 on 2023/12/25.
//

#import "UIViewController+ShowPopup.h"


@implementation UIViewController (ShowPopup)

- (void)presenClearColorPopupController:(UIViewController *)controller {
    STPopupController *popupController = [[STPopupController alloc] initWithRootViewController:controller];
    popupController.navigationBarHidden = YES;
    popupController.hidesCloseButton = YES;
    popupController.containerView.backgroundColor = [UIColor clearColor];
    popupController.backgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
    popupController.transitionStyle = STPopupTransitionStyleFade;
    [popupController presentInViewController:self];
}

- (void)presenPopupController:(UIViewController *)controller {
    STPopupController *popupController = [[STPopupController alloc] initWithRootViewController:controller];
    popupController.navigationBarHidden = YES;
    popupController.hidesCloseButton = YES;
    popupController.containerView.layer.cornerRadius = 10.f;
    popupController.backgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
    popupController.transitionStyle = STPopupTransitionStyleFade;
    [popupController presentInViewController:self];
}

- (void)presenSheetPopupController:(UIViewController *)controller {
    STPopupController *popupController = [[STPopupController alloc] initWithRootViewController:controller];
    popupController.navigationBarHidden = YES;
    popupController.hidesCloseButton = YES;
    popupController.containerView.layer.cornerRadius = 10.f;
    popupController.transitionStyle = STPopupTransitionStyleSlideVertical;
    popupController.style = STPopupStyleBottomSheet;
    [popupController presentInViewController:self];
}


- (void)popupControllerDismiss {
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (weakSelf.presentedViewController) {
            [weakSelf.presentedViewController dismissViewControllerAnimated:YES completion:^{
                [weakSelf.popupController dismiss];
            }];
        }else {
            [weakSelf.popupController dismiss];
        }
    });
}

- (void)popupControllerDismissWithCompletion:(DismissCompletion)completion {
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (weakSelf.presentedViewController) {
            [weakSelf.presentedViewController dismissViewControllerAnimated:YES completion:^{
                [weakSelf.popupController dismissWithCompletion:^{
                    if (completion) {
                        completion();
                    }
                }];
            }];
        }else {
            [weakSelf.popupController dismissWithCompletion:^{
                if (completion) {
                    completion();
                }
            }];
        }
    });
}

- (void)showAlertControllerMessage:(NSString *)message 
                  doneButtonAction:(void(^)(void))doneButtonAction
                cancelButtonAction:(void(^)(void))cancelButtonAction {
    UIAlertController *controler = [UIAlertController alertControllerWithTitle:@"温馨提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *doneAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (doneButtonAction) {
            doneButtonAction();
        }
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        if (cancelButtonAction) {
            cancelButtonAction();
        }
    }];
    
    [controler addAction:doneAction];
    [controler addAction:cancelAction];
    
    [self presentViewController:controler animated:YES completion:nil];
}

- (void)showReloadAlertMessage:(NSString *)message doneButtonAction:(void(^)(void))doneButtonAction {
    UIAlertController *controler = [UIAlertController alertControllerWithTitle:@"请求错误" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *doneAction = [UIAlertAction actionWithTitle:@"重试" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (doneButtonAction) {
            doneButtonAction();
        }
    }];

    [controler addAction:doneAction];
    
    [self presentViewController:controler animated:YES completion:nil];
}

- (void)showExitApplicationAlertMsg:(NSString *)msg {
    UIAlertController *controler = [UIAlertController alertControllerWithTitle:@"提示信息" message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *doneAction = [UIAlertAction actionWithTitle:@"退出应用" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        exit(0);
    }];

    [controler addAction:doneAction];
    
    [self presentViewController:controler animated:YES completion:nil];
}

@end

