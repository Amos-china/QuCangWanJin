//
//  UIButton+ImagePosition.m
//  XKDWallpaper
//
//  Created by 陈志远 on 2024/6/28.
//

#import "UIButton+ImagePosition.h"

@implementation UIButton (ImagePosition)

- (void)setImagePosition:(ImagePosition)postion spacing:(CGFloat)spacing {
    CGFloat imageWith = self.imageView.image.size.width;
    CGFloat imageHeight = self.imageView.image.size.height;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    CGFloat labelWidth = [self.titleLabel.text sizeWithFont:self.titleLabel.font].width;
    CGFloat labelHeight = [self.titleLabel.text sizeWithFont:self.titleLabel.font].height;
#pragma clang diagnostic pop
    
    CGFloat imageOffsetX = (imageWith + labelWidth) / 2 - imageWith / 2;//image中心移动的x距离
    CGFloat imageOffsetY = imageHeight / 2 + spacing / 2;//image中心移动的y距离
    CGFloat labelOffsetX = (imageWith + labelWidth / 2) - (imageWith + labelWidth) / 2;//label中心移动的x距离
    CGFloat labelOffsetY = labelHeight / 2 + spacing / 2;//label中心移动的y距离

    switch (postion) {
        case ImagePositionLeft:
            self.imageEdgeInsets = UIEdgeInsetsMake(0, -spacing/2, 0, spacing/2);
            self.titleEdgeInsets = UIEdgeInsetsMake(0, spacing/2, 0, -spacing/2);
            break;
            
        case ImagePositionRight:
            self.imageEdgeInsets = UIEdgeInsetsMake(0, labelWidth + spacing/2, 0, -(labelWidth + spacing/2));
            self.titleEdgeInsets = UIEdgeInsetsMake(0, -(imageHeight + spacing/2), 0, imageHeight + spacing/2);
            break;
            
        case ImagePositionTop:
            self.imageEdgeInsets = UIEdgeInsetsMake(-imageOffsetY, imageOffsetX, imageOffsetY, -imageOffsetX);
            self.titleEdgeInsets = UIEdgeInsetsMake(labelOffsetY, -labelOffsetX, -labelOffsetY, labelOffsetX);
            break;
            
        case ImagePositionBottom:
            self.imageEdgeInsets = UIEdgeInsetsMake(imageOffsetY, imageOffsetX, -imageOffsetY, -imageOffsetX);
            self.titleEdgeInsets = UIEdgeInsetsMake(-labelOffsetY, -labelOffsetX, labelOffsetY, labelOffsetX);
            break;
            
        default:
            break;
    }
    
}

@end
