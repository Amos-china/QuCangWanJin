//
//  fixCornerBorder.h
//  CommationApp
//
//  Created by 江伟 on 2018/9/20.
//  Copyright © 2018年 iOS开发1. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 全部是圆角适配，如果不需要适配就不要用这个
 **/

@interface UIView (FixLayerCornerBorder)
@property (nonatomic) IBInspectable float fixCorner;
@property (nonatomic) IBInspectable float fixBorderWidth;
@property (nonatomic) IBInspectable UIColor *fixBorderColor;
@property (nonatomic) IBInspectable float fixOGCorner;
@property (nonatomic) IBInspectable UIColor *fixSDColor;
@property (nonatomic) IBInspectable CGSize fixSDOffset;
@property (nonatomic) IBInspectable float fixSDOpacity;
@property (nonatomic) IBInspectable float fixSDRadius;
@end
