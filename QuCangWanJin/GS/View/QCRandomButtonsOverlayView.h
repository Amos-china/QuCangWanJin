#import "QCBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface QCRandomButtonsOverlayView : QCBaseView

/**
 初始化方法
 
 @param frame       视图大小（建议和父视图一样大）
 @param titles      必须正好传 4 个字符串，顺序就是显示顺序
 */
- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray<NSString *> *)titles;

/** 方便在 Storyboard / Xib 使用（虽然一般不会用到） */
- (instancetype)initWithCoder:(NSCoder *)coder NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END
