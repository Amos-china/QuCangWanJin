//
//  QCMainTabbarViewController+ShowNotice.m
//  QuCangWanJin
//
//  Created by 陈志远 on 2025/12/1.
//

#import "QCMainTabbarViewController+ShowNotice.h"
#import "QCCashOutNoticeView.h"

@implementation QCMainTabbarViewController (ShowNotice)

- (void)addNotice {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showNotice:) name:k_SHOW_WX_NOTICE object:nil];
}

- (void)showNotice:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    NSString *value = userInfo[@"key"];
    [self showNoticeView:value];
}

- (void)removeNotice {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)showNoticeView:(NSString *)money {
    [ThreadUtils onUiThreadDelay:5.f onCompletion:^{
        QCCashOutNoticeView *noticeView = [[QCCashOutNoticeView alloc] initWithXib];
        noticeView.money = money;
        noticeView.frame = CGRectMake(10, -200.f, KWidth - 20.f, 86.f);
        ViewRadius(noticeView, 10.f);
        
        UIWindow *keyWindow = nil;
        
        for (UIWindowScene* windowScene in [UIApplication sharedApplication].connectedScenes) {
            if (windowScene.activationState == UISceneActivationStateForegroundActive)
            {
                for (UIWindow *window in windowScene.windows)
                {
                    if (window.isKeyWindow)
                    {
                        keyWindow = window;
                    }
                }
            }
        }
        
        
        [keyWindow addSubview:noticeView];
        
        [UIView animateWithDuration:0.2
                         animations:^{
            noticeView.frame = CGRectMake(10, STATUS_BAR_HEIGHT , KWidth - 20, 86.f);
        }];
        
        __strong typeof(noticeView) strongNoticeView = noticeView;
        [ThreadUtils onUiThreadDelay:2.5 onCompletion:^{
            [UIView animateWithDuration:0.2 animations:^{
                strongNoticeView.frame = CGRectMake(10, -200.f, KWidth - 20, 86.f);
            } completion:^(BOOL finished) {
                if (finished) {
                    [strongNoticeView removeFromSuperview];
                }
            }];
        }];
    }];
}


@end
