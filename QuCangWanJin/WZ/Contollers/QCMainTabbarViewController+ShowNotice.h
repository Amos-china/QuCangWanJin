//
//  QCMainTabbarViewController+ShowNotice.h
//  QuCangWanJin
//
//  Created by 陈志远 on 2025/12/1.
//

#import "QCMainTabbarViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface QCMainTabbarViewController (ShowNotice)

- (void)addNotice;
- (void)removeNotice;

- (void)showNoticeView:(NSString *)money;

@end

NS_ASSUME_NONNULL_END
