//
//  UILabel+Att.m
//  Mudcon
//
//  Created by 陈志远 on 2025/6/24.
//

#import "UILabel+Att.h"

@implementation UILabel (Att)

- (void)setHighlightText:(NSString *)highlightText colorHex:(NSString *)colorHex {
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:self.text];
    NSRange rang = [self.text rangeOfString:highlightText];
    UIColor *color = [UIColor colorWithHexString:colorHex];
    [att yy_setTextHighlightRange:rang color:color backgroundColor:self.backgroundColor userInfo:nil];
    self.attributedText = att;
}

@end
