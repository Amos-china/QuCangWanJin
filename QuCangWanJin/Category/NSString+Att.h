//
//  NSString+Att.h
//  Mudcon
//
//  Created by 陈志远 on 2025/6/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (Att)


- (NSAttributedString *)setHighlightText:(NSString *)highlightText color:(UIColor *)color;
- (NSAttributedString *)setHighlightText:(NSString *)highlightText colorHex:(NSString *)colorHex;
- (NSAttributedString *)setStrokeColorHex:(NSString *)colorHex;


- (NSAttributedString *)setMoneyFontAttMoneySize:(CGFloat)moneySize yuanSize:(CGFloat)yuanSize;
- (NSAttributedString *)setHtmlText;

- (NSAttributedString *)setRedTextAtt:(NSString *)redText;

@end

NS_ASSUME_NONNULL_END
