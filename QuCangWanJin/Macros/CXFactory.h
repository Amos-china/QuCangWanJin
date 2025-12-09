#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CXFactory : NSObject
/**
 *  快速计算出文本的真实尺寸
 *
 *  @param font    文字的字体
 *  @param maxSize 文本的最大尺寸
 *
 *  @return 快速计算出文本的高度
 */
+ (CGFloat)getHeightWithFont:(UIFont *)font andMaxSize:(CGSize)maxSize andString:(NSString *)str;
/**
 *  快速计算出文本的真实尺寸
 *
 *  @param font    文字的字体
 *  @param maxSize 文本的最大尺寸
 *
 *  @return 快速计算出文本的宽度
 */
+ (CGFloat)getWidthWithFont:(UIFont *)font andMaxSize:(CGSize)maxSize andString:(NSString *)str;


//获取手机具体型号
+ (NSString*)deviceModelName;


//获取UUID
+ (NSString *)getUUID;

//字典转Json字符串
// 字典转json字符串方法

+(NSString *)convertToJsonData:(NSDictionary *)dict;

#pragma mark - JSON字符串转字典
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

//时间戳转换为时间
+(NSString *)timestampToTimeWithString:(NSString *)timestamp withFormat:(NSString *)formatString;

/**
    创建view
 */

+(UIView*)initViewWithBackGroundColor:(UIColor*)color withIsLayer:(BOOL)isLayer withCornerRadius:(CGFloat)radius withBorderWidth:(CGFloat)borderWidth withBorderColor:(UIColor*)borderColor;

/**
    创建label
 textAlignment 1左对齐 2居中 3右对齐
 */
+(UILabel*)initLabelWithText:(NSString *)text withTextColor:(UIColor*)color withFontSize:(UIFont*)font withTextAlignment:(NSInteger)textAlignment;

/**
    创建imageView
 */

+(UIImageView*)initImageWithImage:(UIImage*)image withIsLayer:(BOOL)isLayer withCornerRadius:(CGFloat)radius withBorderWidth:(CGFloat)borderWidth withBorderColor:(UIColor*)borderColor;

/*
    创建按钮 不带图片
 *
 */
+ (UIButton *)buttonWithBackgroundColor:(UIColor *)backgroundColor title:(NSString *)title titleColor:(UIColor *)color fontSize:(UIFont*)size withIsLayer:(BOOL)isLayer cornerRadius:(float)radius;

/*
    创建textField
 *
 */

+(UITextField *)textFieldWithPlaceholder:(NSString *)placeholder text:(NSString *)text backgroundColor:(UIColor *)bgColor textColor:(UIColor *)textColor center:(BOOL)center delegate:(id)delegate returnKeyType:(NSInteger)returnKeyType keyboardType:(NSInteger)keyboardType fontSize:(UIFont*)fontSize secure:(BOOL)secure;

/*
    创建tableview
 */
+(UITableView*)tableViewWithFrame:(CGRect)frame withBackgroundColor:(UIColor*)bgColor;



//时间戳转换为时间
+(NSString *)timestampToTimeWithString:(NSString *)timestamp timeformat:(NSString *)format;




/* 颜色值 */
+ (UIColor *) colorWithHexString: (NSString *)color;


@end

NS_ASSUME_NONNULL_END
