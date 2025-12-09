//
//  UIView+Animation.m
//  MelonTheater
//
//  Created by 陈志远 on 2023/12/22.
//

#import "UIView+Animation.h"

@implementation UIView (Animation)


//不停地旋转
- (void)viewNonstopRotationAnimation {
    __weak typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        CABasicAnimation* rotationAnimation;
        rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
        rotationAnimation.duration = 3;
        rotationAnimation.cumulative = YES;
        rotationAnimation.repeatCount = HUGE;
        rotationAnimation.removedOnCompletion = NO;
        [weakSelf.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    });
}

- (void)viewWaggleEnterAnimal {
    __weak typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.translation"];
        // 动画选项设定
        animation.duration = 0.5; // 动画持续时间
        animation.repeatCount = HUGE; // 重复次数无限次HUGE
        animation.autoreverses = YES; //（重点设置为NO闪回）// 动画结束时执行逆动画
        // 起始点
        animation.fromValue = [NSValue valueWithCGPoint:CGPointMake(0, 0)]; // 开始时坐标
        animation.toValue = [NSValue valueWithCGPoint:CGPointMake(0, 5)]; // 结束时的坐标
        animation.removedOnCompletion = NO;
        // 添加动画
        [weakSelf.layer addAnimation:animation forKey:@"translation"];
    });
    //
  
}

//开始放大动画
- (void)beginEnlargeAnimation {
    __weak typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        CABasicAnimation *animation = [CABasicAnimation animation];
        //必须加transform,不然会不起作用
        animation.keyPath = @"transform.scale";
        animation.fromValue = @(1.0);
        animation.toValue = @(1.2);
        animation.duration = 0.7f;
        animation.beginTime = 0.f;
        animation.repeatCount = HUGE; // 重复次数无限次HUGE
       //动画后保持最终的动画状态
        animation.autoreverses = YES;
        animation.removedOnCompletion = NO;
    //    animation.fillMode = kCAFillModeForwards;
        [weakSelf.layer addAnimation:animation forKey:@"animation2"];
    });
   
}



@end
