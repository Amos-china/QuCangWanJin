//
//  UILabel+TextFont.m
//  Mudcon
//
//  Created by 陈志远 on 2025/6/20.
//

#import "UILabel+TextFont.h"

@implementation UILabel (TextFont)

- (void)setStrokeColor:(UIColor *)strokeColor {
    NSDictionary *attributes = @{
        NSFontAttributeName: self.font,
        NSForegroundColorAttributeName: self.textColor,
        NSStrokeColorAttributeName: strokeColor,
        NSStrokeWidthAttributeName: @-3.0
    };
    NSAttributedString *att = [[NSAttributedString alloc] initWithString:self.text attributes:attributes];
    self.attributedText = att;
}

- (void)setStrokeColorHex:(NSString *)colorHex {
    UIColor *color = [UIColor colorWithHexString:colorHex];
    NSDictionary *attributes = @{
        NSFontAttributeName: self.font,
        NSForegroundColorAttributeName: self.textColor,
        NSStrokeColorAttributeName: color,
        NSStrokeWidthAttributeName: @-3.0
    };
    NSAttributedString *att = [[NSAttributedString alloc] initWithString:self.text attributes:attributes];
    self.attributedText = att;
}

@end
