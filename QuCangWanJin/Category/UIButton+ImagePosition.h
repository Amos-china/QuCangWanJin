//
//  UIButton+ImagePosition.h
//  XKDWallpaper
//
//  Created by 陈志远 on 2024/6/28.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


typedef NS_ENUM(NSInteger, ImagePosition) {
    ImagePositionLeft = 0,              //图片在左，文字在右，默认
    ImagePositionRight = 1,             //图片在右，文字在左
    ImagePositionTop = 2,               //图片在上，文字在下
    ImagePositionBottom = 3,            //图片在下，文字在上
};

@interface UIButton (ImagePosition)

- (void)setImagePosition:(ImagePosition)postion spacing:(CGFloat)spacing;

@end

NS_ASSUME_NONNULL_END
