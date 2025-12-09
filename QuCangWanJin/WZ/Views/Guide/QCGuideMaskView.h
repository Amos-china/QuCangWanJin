//
//  GSGuideMaskView.h
//  Mudcon
//
//  Created by 陈志远 on 2025/7/2.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN



@interface QCGuideMaskView : UIView

@property (nonatomic, copy) void(^touchFrameActionCallBack)(void);

- (void)addGameContollrtFrame:(CGRect)frame buttonFrame:(CGRect)buttonFrame;
- (void)addHomeHollowOne:(CGRect)oneFrame twoFrame:(CGRect)twoFrame finger:(NSInteger)fingerIndex;
- (void)addCashHollowFrame:(CGRect)viewFrame buttonFrame:(CGRect)buttonFrame;

// 添加需要镂空的视图（自动计算位置）
- (void)addHollowView:(UIView *)hollowView cornerRadius:(CGFloat)radius;

// 添加自定义镂空区域（使用CGRect）
- (void)addHollowRect:(CGRect)rect cornerRadius:(CGFloat)radius;

- (void)show;

- (void)hide;

@end

NS_ASSUME_NONNULL_END
