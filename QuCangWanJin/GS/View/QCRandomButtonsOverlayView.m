#import "QCRandomButtonsOverlayView.h"

@interface QCRandomButtonsOverlayView ()

@property (nonatomic, copy) NSArray<NSString *> *titles;

@end

@implementation QCRandomButtonsOverlayView

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray<NSString *> *)titles {
    self = [super initWithFrame:frame];
    if (self) {
        _titles = @[@"按ssss钮1", @"按sss钮2", @"按钮3", @"按钮4"];
        [self setupUI];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        _titles = @[@"按ssss钮1", @"按sss钮2", @"按钮3", @"按钮4"];
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor clearColor];
    [self placeButtonsWithRedBorderStyle];
}

#pragma mark - 智能随机布局（横竖混排 + 视觉均匀）

- (void)placeButtonsWithRedBorderStyle {
    UIEdgeInsets safe = UIEdgeInsetsMake(60, 40, 60, 40);   // 更大留白，更高级
    CGRect area = UIEdgeInsetsInsetRect(self.bounds, safe);
    
    // 高纯度红色边框（和你的图一模一样）
    UIColor *redBorder = [UIColor colorWithRed:255/255.0 green:59/255.0 blue:48/255.0 alpha:1.0];
    
    NSMutableArray<NSValue *> *occupied = [NSMutableArray array];
    
    for (NSInteger i = 0; i < 4; i++) {
        NSString *text = self.titles[i];
        
        // 随机横/竖（40% 概率竖）
        BOOL vertical = arc4random_uniform(100) < 40;
        
        // 文字尺寸计算
        UIFont *font = [UIFont boldSystemFontOfSize:18];
        CGSize textSize = [text sizeWithAttributes:@{NSFontAttributeName: font}];
        
        CGFloat hPadding = vertical ? 24 : 32;
        CGFloat vPadding = vertical ? 32 : 24;
        
        CGSize btnSize = vertical ?
            CGSizeMake(textSize.height + vPadding, textSize.width + hPadding) :
            CGSizeMake(textSize.width + hPadding, textSize.height + vPadding);
        
        // 随机位置（大量尝试 + 膨胀检测区 = 视觉均匀）
        CGRect finalRect = CGRectZero;
        for (int try = 0; try < 150; try++) {
            CGFloat x = safe.left + arc4random_uniform((uint32_t)(area.size.width - btnSize.width));
            CGFloat y = safe.top + arc4random_uniform((uint32_t)(area.size.height - btnSize.height));
            CGRect rect = CGRectMake(x, y, btnSize.width, btnSize.height);
            
            CGRect checkRect = CGRectInset(rect, -50, -50); // 检测范围放大，防止太密集
            BOOL overlap = NO;
            for (NSValue *v in occupied) {
                if (CGRectIntersectsRect(checkRect, v.CGRectValue)) {
                    overlap = YES;
                    break;
                }
            }
            if (!overlap) {
                finalRect = rect;
                break;
            }
        }
        
        if (CGRectIsEmpty(finalRect)) {
            finalRect = CGRectMake(80 + i*50, 120 + i*80, btnSize.width, btnSize.height);
        }
        
        // 创建按钮
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = finalRect;
        btn.backgroundColor = UIColor.whiteColor;
        btn.layer.cornerRadius = 8;
        btn.layer.borderWidth = 2.0f;               // 粗红边框
        btn.layer.borderColor = redBorder.CGColor;
        btn.clipsToBounds = YES;
        
        [btn setTitle:text forState:UIControlStateNormal];
        [btn setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
        btn.titleLabel.font = font;
        
        // 竖向按钮旋转 90°
        if (vertical) {
            btn.transform = CGAffineTransformMakeRotation(M_PI_2);
        }
        
        [self addSubview:btn];
        [occupied addObject:[NSValue valueWithCGRect:finalRect]];
    }
}
@end
