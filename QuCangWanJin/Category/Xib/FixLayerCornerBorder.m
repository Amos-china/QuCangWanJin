//
//  fixCornerBorder.m
//  CommationApp
//
//  Created by 江伟 on 2018/9/20.
//  Copyright © 2018年 iOS开发1. All rights reserved.
//

#import "FixLayerCornerBorder.h"
#import <objc/runtime.h>

@implementation UIView (fixCornerBorder)

- (void)setFixCorner:(float)fixCorner {
    if (fixCorner > 0) {
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = fixCorner;
    }
}

- (float)fixCorner {
    return self.fixCorner;
}

- (void)setFixBorderColor:(UIColor *)fixBorderColor {
    if (fixBorderColor != nil) {
        self.layer.masksToBounds = YES;
        self.layer.borderColor = fixBorderColor.CGColor;
    }
}

- (void)setFixOGCorner:(float)fixOGCorner {
    if (fixOGCorner > 0) {
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = fixOGCorner;
    }
}

- (float)fixOGCorner {
    return self.fixOGCorner;
}


- (UIColor *)fixBorderColor {
    return self.fixBorderColor;
}

- (void)setFixBorderWidth:(float)fixBorderWidth {
    if (fixBorderWidth > 0) {
        self.layer.masksToBounds = YES;
        self.layer.borderWidth = fixBorderWidth;
    }
}

- (float)fixBorderWidth {
    return self.fixBorderWidth;
}

- (void)setFixSDColor:(UIColor *)fixSDColor {
    if (fixSDColor != nil) {
        self.layer.shadowColor = fixSDColor.CGColor;
    }
}

- (UIColor *)fixSDColor {
    return self.fixSDColor;
}


- (void)setFixSDOffset:(CGSize )fixSDOffset {
    if (fixSDOffset.width != 0 || fixSDOffset.height != 0) {
        self.layer.shadowOffset = fixSDOffset;
    }
}

- (CGSize)fixSDOffset {
    return self.fixSDOffset;
}

- (void)setFixSDOpacity:(float)fixSDOpacity {
    if (fixSDOpacity > 0) {
        self.layer.shadowOpacity = fixSDOpacity;
    }
}

- (float)fixSDOpacity {
    return self.fixSDOpacity;
}

- (void)setFixSDRadius:(float)fixSDRadius {
    if (fixSDRadius > 0) {
        self.layer.shadowRadius = fixSDRadius;
    }
}

- (float)fixSDRadius {
    return self.fixSDRadius;
}

- (void)setIsAdapter:(BOOL)isAdapter {
    
}

@end
