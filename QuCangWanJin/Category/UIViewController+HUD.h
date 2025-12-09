//
//  UIViewController+HUD.h
//  MelonTheater
//
//  Created by 陈志远 on 2023/12/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (HUD)

- (void)showToast:(NSString *)text;

- (void)showCustomToast:(NSString *)text;

- (void)showHUD;
- (void)dismissHUD;

@end

NS_ASSUME_NONNULL_END
