//
//  GSGuideMaskView.m
//  Mudcon
//
//  Created by 陈志远 on 2025/7/2.
//

#import "QCGuideMaskView.h"

@interface QCGuideMaskView ()

@property (nonatomic, assign) BOOL isHome;
@property (nonatomic, assign) CGRect homeFrame;

@end

@implementation QCGuideMaskView {
    NSMutableArray<UIBezierPath *> *_hollowPaths;
    CGRect _touchRect;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _hollowPaths = [NSMutableArray array];
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (void)addGameContollrtFrame:(CGRect)frame buttonFrame:(CGRect)buttonFrame {
    self.isHome = YES;
    self.homeFrame = frame;
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:frame cornerRadius:10.f];
    [_hollowPaths addObject:path];
    _touchRect = buttonFrame;
    [self setNeedsDisplay];
}

- (void)addHomeHollowOne:(CGRect)oneFrame twoFrame:(CGRect)twoFrame finger:(NSInteger)fingerIndex {
    CGFloat radius = oneFrame.size.width / 2;
    UIBezierPath *onePath = [UIBezierPath bezierPathWithRoundedRect:oneFrame cornerRadius:radius];
    UIBezierPath *twoPath = [UIBezierPath bezierPathWithRoundedRect:twoFrame cornerRadius:radius];
    [_hollowPaths addObject:onePath];
    [_hollowPaths addObject:twoPath];

    _touchRect = fingerIndex == 0 ? oneFrame : twoFrame;
    
    [self setNeedsDisplay];
}

- (void)addCashHollowFrame:(CGRect)viewFrame buttonFrame:(CGRect)buttonFrame {
    viewFrame.origin.y = STATUS_BAR_HEIGHT + 44.f + 14.f;
    buttonFrame.origin.y = buttonFrame.origin.y + STATUS_BAR_HEIGHT + 44.f;
    _touchRect = buttonFrame;
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:viewFrame cornerRadius:10];
    [_hollowPaths addObject:path];
    [self setNeedsDisplay];
}

// 添加需要镂空的视图
- (void)addHollowView:(UIView *)hollowView cornerRadius:(CGFloat)radius {
    CGRect rect = [self convertRect:hollowView.frame fromView:hollowView.superview];
    [self addHollowRect:rect cornerRadius:radius];
}

// 添加自定义镂空区域
- (void)addHollowRect:(CGRect)rect cornerRadius:(CGFloat)radius {
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:radius];
    [_hollowPaths addObject:path];
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    // 设置背景色和透明度
    [[UIColor colorWithWhite:0 alpha:0.7] setFill];
    
    // 创建主路径（全屏）
    UIBezierPath *backgroundPath = [UIBezierPath bezierPathWithRect:self.bounds];
    
    // 添加所有镂空路径
    for (UIBezierPath *hollowPath in _hollowPaths) {
        [backgroundPath appendPath:hollowPath];
    }
    
    // 使用奇偶规则填充（镂空关键）
    backgroundPath.usesEvenOddFillRule = YES;
    [backgroundPath fill];
    
    UIButton *touchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    touchButton.frame = _touchRect;
    [touchButton addTarget:self action:@selector(touchButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:touchButton];
    
    CGSize fingrSize = CGSizeMake(60.f, 60.f);
    CGFloat y = CGRectGetMinY(_touchRect) + _touchRect.size.height / 2;
    CGFloat x = CGRectGetMaxX(_touchRect) - fingrSize.width * 2 / 3;
    
    CGRect fingrFrame = CGRectMake(x, y, fingrSize.width, fingrSize.height);
    
    UIImageView *fingrImageView = [[UIImageView alloc] initWithFrame:fingrFrame];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"yindao_shouzhi" ofType:@"gif"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    UIImage *image = [UIImage sd_imageWithGIFData:data];
    fingrImageView.image = image;
    [self addSubview:fingrImageView];
    
    if (self.isHome) {
        // 1. 创建 UIImageView
        UIImageView *guidIm = [[UIImageView alloc] init];
        UIImage *image = [UIImage imageNamed:@"guide-bg2"]; // 替换为你的图片名称
        guidIm.image = image;

        // 2. 计算 imageView 的 frame
        CGSize imageSize = image.size;
        CGFloat imageViewWidth = imageSize.width;
        CGFloat imageViewHeight = imageSize.height;

        // 计算 imageView 的 y 坐标（在 originalRect 上方 20pt）
        CGFloat imageViewY = CGRectGetMinY(self.homeFrame) - 20 - imageViewHeight;

        // 计算 imageView 的 x 坐标（水平居中）
        CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
        CGFloat imageViewX = (screenWidth - imageViewWidth) / 2;

        // 设置 imageView 的 frame
        guidIm.frame = CGRectMake(imageViewX, imageViewY, imageViewWidth, imageViewHeight);
        
        [self addSubview:guidIm];
    }

}

- (void)touchButtonAction {
    if (self.touchFrameActionCallBack) {
        self.touchFrameActionCallBack();
    }
    [self hide];
}

- (void)show {
    [[self getCurrentKeyWindow] addSubview:self];
}

- (void)hide {
    [self removeFromSuperview];
}


- (UIWindow *)getCurrentKeyWindow {
    UIWindow *keyWindow = nil;
    
    if (@available(iOS 13.0, *)) {
        for (UIScene *scene in [UIApplication sharedApplication].connectedScenes) {
            if (scene.activationState == UISceneActivationStateForegroundActive) {
                UIWindowScene *windowScene = (UIWindowScene *)scene;
                for (UIWindow *window in windowScene.windows) {
                    if (window.isKeyWindow) {
                        keyWindow = window;
                        break;
                    }
                }
                if (keyWindow) break;
            }
        }
    } else {
        keyWindow = [UIApplication sharedApplication].keyWindow;
    }
    
    // 备用方案
    if (!keyWindow) {
        keyWindow = [[UIApplication sharedApplication].windows firstObject];
    }
    
    return keyWindow;
}

@end
