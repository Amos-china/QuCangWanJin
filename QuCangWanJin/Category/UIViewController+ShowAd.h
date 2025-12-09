//
//  UIViewController+ShowAd.h
//  MelonTheater
//
//  Created by 陈志远 on 2024/1/18.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (ShowAd)

@property (nonatomic, copy) CloseAdCompletionHandler closeAdCompletionHanlder;

- (void)showSettlementSwitchAd;
- (void)changedControllerShowSwitchAd;

@end

NS_ASSUME_NONNULL_END
