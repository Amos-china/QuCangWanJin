//
//  NSString+Att.m
//  Mudcon
//
//  Created by 陈志远 on 2025/6/24.
//

#import "NSString+Att.h"

@implementation NSString (Att)

- (NSAttributedString *)setHighlightText:(NSString *)highlightText colorHex:(NSString *)colorHex {
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:self];
    NSRange rang = [self rangeOfString:highlightText];
    UIColor *color = [UIColor colorWithHexString:colorHex];
    [att addAttributes:@{NSForegroundColorAttributeName:color} range:rang];
    return att;
}

- (NSAttributedString *)setHighlightText:(NSString *)highlightText color:(UIColor *)color {
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:self];
    NSRange rang = [self rangeOfString:highlightText];
    [att addAttributes:@{NSForegroundColorAttributeName:color} range:rang];
    return att;
}


- (NSAttributedString *)setStrokeColorHex:(NSString *)colorHex {
    UIColor *color = [UIColor colorWithHexString:colorHex];
    NSDictionary *attributes = @{
        NSStrokeColorAttributeName: color,
        NSStrokeWidthAttributeName: @-3.0
    };
    NSAttributedString *att = [[NSAttributedString alloc] initWithString:self attributes:attributes];
    return att;
}

- (NSAttributedString *)setMoneyFontAttMoneySize:(CGFloat)moneySize yuanSize:(CGFloat)yuanSize {
    UIColor *textColor = [UIColor colorWithHexString:@"#FF3B30"];
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:self];
    NSRange moneyRang = NSMakeRange(0, self.length - 1);
    NSRange yuanRang = NSMakeRange(self.length - 1, 1);
    [att addAttribute:NSForegroundColorAttributeName value:textColor range:NSMakeRange(0, self.length)];
    [att addAttribute:NSFontAttributeName value:APPFONT(moneySize) range:moneyRang];
    [att addAttribute:NSFontAttributeName value:APPFONT(yuanSize) range:yuanRang];
    return att;
}

- (NSAttributedString *)setHtmlText {
    //富文本，两种都可以
    NSDictionary *options = @{ NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute :@(NSUTF8StringEncoding) };
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    //或者
//    NSDictionary *option = @{NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType};
//    NSData *data = [htmlStr dataUsingEncoding:NSUnicodeStringEncoding];
    
    //设置富文本
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithData:data options:options documentAttributes:nil error:nil];
    //设置段落格式
//    NSMutableParagraphStyle *para = [[NSMutableParagraphStyle alloc] init];
//    para.lineSpacing = 7;
//    para.paragraphSpacing = 10;
//    [attStr addAttribute:NSParagraphStyleAttributeName value:para range:NSMakeRange(0, attStr.length)];
    //设置文本的Font没有效果，默认12字号，这个只能服务器端控制吗？ 暂时没有找到方法修改字号
    [attStr addAttribute:NSFontAttributeName value:APPFONT(14.f) range:NSMakeRange(0, attStr.length)];
    return attStr;
}

- (NSAttributedString *)setRedTextAtt:(NSString *)redText {
    UIColor *redColor = [UIColor colorWithHexString:@"#FF3B30"];
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:self];
    NSRange moneyRang = [self rangeOfString:redText];
    [att addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(moneyRang.length - 1, self.length - moneyRang.length)];
    [att addAttribute:NSForegroundColorAttributeName value:redColor range:moneyRang];
    return att;
}

@end
