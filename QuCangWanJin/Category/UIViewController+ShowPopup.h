//
//  UIViewController+ShowPopup.h
//  MelonTheater
//
//  Created by 陈志远 on 2023/12/25.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

typedef void(^DismissCompletion)(void);

@interface UIViewController (ShowPopup)

- (void)presenClearColorPopupController:(UIViewController *)controller ;
- (void)presenPopupController:(UIViewController *)controller;
- (void)presenSheetPopupController:(UIViewController *)controller;

- (void)popupControllerDismiss;
- (void)popupControllerDismissWithCompletion:(DismissCompletion)completion;


- (void)showAlertControllerMessage:(NSString *)message
                  doneButtonAction:(void(^)(void))doneButtonAction
                cancelButtonAction:(void(^)(void))cancelButtonAction;

- (void)showReloadAlertMessage:(NSString *)message doneButtonAction:(void(^)(void))doneButtonAction;
- (void)showExitApplicationAlertMsg:(NSString *)msg;

@end

NS_ASSUME_NONNULL_END
