//
//  FixScreenFont.m
//  CommationApp
//
//  Created by 江伟 on 2018/9/20.
//  Copyright © 2018年 iOS开发1. All rights reserved.
//

#import "FixScreenFont.h"
@implementation UILabel (FixScreenFont)

- (void)setFixFont:(float)fixFont{
    
    if (fixFont > 0 ) {
        NSString *fontName = @"Resource-Han-Rounded-CN-Bold";
        self.font = [UIFont fontWithName:fontName size:aufont(fixFont)];
    } else {
        self.font = self.font;
    }
}

- (float )fixFont{
    return aufont(self.fixFont);
}

@end


@implementation UIButton (FixScreenFont)

- (void)setFixFont:(float)fixFont{
    
    if (fixFont > 0 ) {
        NSString *fontName = @"Resource-Han-Rounded-CN-Bold";
        self.titleLabel.font = [UIFont fontWithName:fontName size:aufont(fixFont)];
    } else {
        self.titleLabel.font = self.titleLabel.font;
    }
}

- (float )fixFont{
    return aufont(self.fixFont);
}

@end

@implementation UITextField (FixScreenFont)

- (void)setFixFont:(float)fixFont{
    if (fixFont > 0 ) {
        NSString *fontName = @"Resource-Han-Rounded-CN-Bold";
        self.font = [UIFont fontWithName:fontName size:aufont(fixFont)];
    } else {
        self.font = self.font;
    }
}

- (float )fixFont{
    return aufont(self.fixFont);
}

@end

@implementation UITextView (FixScreenFont)

- (void)setFixFont:(float)fixFont {
    if (fixFont > 0 ) {
        NSString *fontName = @"Resource-Han-Rounded-CN-Bold";
        self.font = [UIFont fontWithName:fontName size:aufont(fixFont)];
    } else {
        self.font = self.font;
    }
}

- (float )fixFont {
    return aufont(self.fixFont);
}

@end
