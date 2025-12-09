#import "CXFactory.h"
#import <sys/utsname.h>

@implementation CXFactory
+ (CGFloat)getHeightWithFont:(UIFont *)font andMaxSize:(CGSize)maxSize andString:(NSString *)str
{
    NSDictionary *arrts = @{NSFontAttributeName:font};
    CGRect rect = [str boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:arrts context:nil];
    return rect.size.height;
}

+ (CGFloat)getWidthWithFont:(UIFont *)font andMaxSize:(CGSize)maxSize andString:(NSString *)str
{
    NSDictionary *arrts = @{NSFontAttributeName:font};
    CGRect rect = [str boundingRectWithSize:maxSize options:NSStringDrawingTruncatesLastVisibleLine |
                   NSStringDrawingUsesLineFragmentOrigin |
                   NSStringDrawingUsesFontLeading attributes:arrts context:nil];
    return rect.size.width;
}
//时间戳转换为时间
+(NSString *)timestampToTimeWithString:(NSString *)timestamp withFormat:(NSString *)formatString{
    
    NSTimeInterval _interval=[timestamp doubleValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
    NSDateFormatter *objDateformat = [[NSDateFormatter alloc] init];
    [objDateformat setDateFormat:formatString];
    return [objDateformat stringFromDate:date];
    
}
//获取UUID
+ (NSString *)getUUID{
    return [UIDevice currentDevice].identifierForVendor.UUIDString;;
}

//获取手机具体型号
+ (NSString*)deviceModelName{
    struct utsname systemInfo;
     uname(&systemInfo);
     NSString *phoneType = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];

     if([phoneType  isEqualToString:@"iPhone7,1"])  return @"iPhone 6 Plus";

     if([phoneType  isEqualToString:@"iPhone7,2"])  return @"iPhone 6";

     if([phoneType  isEqualToString:@"iPhone8,1"])  return @"iPhone 6s";

     if([phoneType  isEqualToString:@"iPhone8,2"])  return @"iPhone 6s Plus";

     if([phoneType  isEqualToString:@"iPhone8,4"])  return @"iPhone SE";

     if([phoneType  isEqualToString:@"iPhone9,1"])  return @"iPhone 7";

     if([phoneType  isEqualToString:@"iPhone9,2"])  return @"iPhone 7 Plus";

     if([phoneType  isEqualToString:@"iPhone10,1"]) return @"iPhone 8";

     if([phoneType  isEqualToString:@"iPhone10,4"]) return @"iPhone 8";

     if([phoneType  isEqualToString:@"iPhone10,2"]) return @"iPhone 8 Plus";

     if([phoneType  isEqualToString:@"iPhone10,5"]) return @"iPhone 8 Plus";

     if([phoneType  isEqualToString:@"iPhone10,3"]) return @"iPhone X";

     if([phoneType  isEqualToString:@"iPhone10,6"]) return @"iPhone X";

     if([phoneType  isEqualToString:@"iPhone11,8"]) return @"iPhone XR";

     if([phoneType  isEqualToString:@"iPhone11,2"]) return @"iPhone XS";

     if([phoneType  isEqualToString:@"iPhone11,4"]) return @"iPhone XS Max";

     if([phoneType  isEqualToString:@"iPhone11,6"]) return @"iPhone XS Max";

     if([phoneType  isEqualToString:@"iPhone12,1"]) return @"iPhone 11";

     if([phoneType  isEqualToString:@"iPhone12,3"]) return @"iPhone 11 Pro";

     if([phoneType  isEqualToString:@"iPhone12,5"]) return @"iPhone 11 Pro Max";

     if([phoneType  isEqualToString:@"iPhone12,8"]) return @"iPhone SE2";

    if([phoneType  isEqualToString:@"iPhone13,1"]) return @"iPhone 12 mini";

     if([phoneType  isEqualToString:@"iPhone13,2"]) return @"iPhone 12";

     if([phoneType  isEqualToString:@"iPhone13,3"]) return @"iPhone 12 Pro";

     if([phoneType  isEqualToString:@"iPhone13,4"]) return @"iPhone 12 Pro Max";

     if([phoneType  isEqualToString:@"iPhone14,4"]) return @"iPhone 13 mini";

     if([phoneType  isEqualToString:@"iPhone14,5"]) return @"iPhone 13";

     if([phoneType  isEqualToString:@"iPhone14,2"]) return @"iPhone 13 Pro";

     if([phoneType  isEqualToString:@"iPhone14,3"]) return @"iPhone 13 Pro Max";

     if([phoneType  isEqualToString:@"iPhone14,6"]) return @"iPhone SE3";

     if([phoneType  isEqualToString:@"iPhone14,7"]) return @"iPhone 14";

     if([phoneType  isEqualToString:@"iPhone14,8"]) return @"iPhone 14 Plus";

     if([phoneType  isEqualToString:@"iPhone15,2"]) return @"iPhone 14 Pro";

     if([phoneType  isEqualToString:@"iPhone15,3"]) return @"iPhone 14 Pro Max";
    
    if([phoneType  isEqualToString:@"iPhone15,4"]) return @"iPhone 15";

    if([phoneType  isEqualToString:@"iPhone15,5"]) return @"iPhone 15 Plus";

    if([phoneType  isEqualToString:@"iPhone16,1"]) return @"iPhone 15 Pro";

    if([phoneType  isEqualToString:@"iPhone16,2"]) return @"iPhone 15 Pro Max";
    
    if([phoneType  isEqualToString:@"iPhone17,1"]) return @"iPhone 16 Pro";
    
    if([phoneType  isEqualToString:@"iPhone17,2"]) return @"iPhone 16 Pro Max";
    
    if([phoneType  isEqualToString:@"iPhone17,3"]) return @"iPhone 16";
    
    if([phoneType  isEqualToString:@"iPhone17,4"]) return @"iPhone 16 Plus";
    
     return @"iPhone";

}






+(NSString *)convertToJsonData:(NSDictionary *)dict
{
NSError *error;

   NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];

   NSString *jsonString;

   if (!jsonData) {

       NSLog(@"%@",error);

   }else{

       jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];

   }

   NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];

   NSRange range = {0,jsonString.length};

   //去掉字符串中的空格

   [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];

   NSRange range2 = {0,mutStr.length};

   //去掉字符串中的换行符

   [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];

   return mutStr;
}


#pragma mark - JSON字符串转字典
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}


/**
 创建view
 */

+(UIView*)initViewWithBackGroundColor:(UIColor*)color withIsLayer:(BOOL)isLayer withCornerRadius:(CGFloat)radius withBorderWidth:(CGFloat)borderWidth withBorderColor:(UIColor*)borderColor{
    UIView *view = [[UIView alloc] init];
    if (isLayer) {
        view.layer.masksToBounds = YES;
        view.layer.cornerRadius = radius;
        view.layer.borderWidth = borderWidth;
        view.layer.borderColor = borderColor.CGColor;
    }
    view.backgroundColor = color;
    return view;
}

/**
 创建label
 textAlignment 1左对齐 2居中 3右对齐
 */
+(UILabel*)initLabelWithText:(NSString *)text withTextColor:(UIColor*)color withFontSize:(UIFont*)font withTextAlignment:(NSInteger)textAlignment{
    UILabel *label = [[UILabel alloc] init];
    label.text = text;
    label.numberOfLines = 0;
    switch (textAlignment) {
        case 1:
            label.textAlignment = NSTextAlignmentLeft;
            break;
        case 2:
            label.textAlignment = NSTextAlignmentCenter;
            break;
        case 3:
            label.textAlignment = NSTextAlignmentRight;
            break;
        default:
            break;
    }
    label.userInteractionEnabled = YES;
    label.font = font;
    label.textColor = color;
    return label;

}



/**
 创建imageView
 */

+(UIImageView*)initImageWithImage:(UIImage*)image withIsLayer:(BOOL)isLayer withCornerRadius:(CGFloat)radius withBorderWidth:(CGFloat)borderWidth withBorderColor:(UIColor*)borderColor{
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = image;
    if (isLayer) {
        imageView.layer.masksToBounds = YES;
        imageView.layer.cornerRadius = radius;
        imageView.layer.borderColor = borderColor.CGColor;
        imageView.layer.borderWidth = borderWidth;
    }
    imageView.userInteractionEnabled = YES;
    return imageView;
}

+ (UIButton *)buttonWithBackgroundColor:(UIColor *)backgroundColor title:(NSString *)title titleColor:(UIColor *)color fontSize:(UIFont*)size withIsLayer:(BOOL)isLayer cornerRadius:(float)radius{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = backgroundColor;
    if (isLayer) {
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius  =radius;
    }
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:color forState:UIControlStateNormal];
    button.titleLabel.font = size;
    //    button.titleLabel.font = [UIFont fontWithName:@"Helvetica-bold" size:size];
    return button;
}


+(UITextField *)textFieldWithPlaceholder:(NSString *)placeholder text:(NSString *)text backgroundColor:(UIColor *)bgColor textColor:(UIColor *)textColor center:(BOOL)center delegate:(id)delegate returnKeyType:(NSInteger)returnKeyType keyboardType:(NSInteger)keyboardType fontSize:(UIFont*)fontSize secure:(BOOL)secure{
    UITextField *textField = [[UITextField alloc] init];
    textField.text = text;
    textField.placeholder = placeholder;
    textField.backgroundColor = bgColor;
    textField.delegate = delegate;
    [textField setValue:fontSize forKeyPath:@"_placeholderLabel.font"];
    textField.keyboardType = keyboardType;
    textField.textColor = textColor;
    if (center) {
        textField.textAlignment = NSTextAlignmentCenter;
    }else{
        textField.textAlignment = NSTextAlignmentLeft;
    }
    if (secure) {
        textField.secureTextEntry = YES;
    }
    textField.font = fontSize;
    return textField;
    
}

//+(UITableView*)tableViewWithFrame:(CGRect)frame withBackgroundColor:(UIColor *)bgColor{
//    UITableView *_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, Height_NavBar, AppWidth, AppHeight-Height_NavBar) style:UITableViewStylePlain];
//    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    _tableView.separatorColor = [UIColor clearColor];
//    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
//    _tableView.showsVerticalScrollIndicator = NO;
//    _tableView.showsHorizontalScrollIndicator = NO;
//    return _tableView;
//}




+(NSString *)timestampToTimeWithString:(NSString *)timestamp timeformat:(NSString *)format{
    
    NSTimeInterval _interval=[timestamp doubleValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
    NSDateFormatter *objDateformat = [[NSDateFormatter alloc] init];
    [objDateformat setDateFormat:format];
    return [objDateformat stringFromDate:date];
    
}

+ (UIColor *) colorWithHexString: (NSString *)color
{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    //r
    NSString *rString = [cString substringWithRange:range];
    
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}
@end
