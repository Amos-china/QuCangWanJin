
#import <Foundation/Foundation.h>

/*
 全部是适配字体，如果不需要适配就不要用这个
 **/

@interface UILabel (FixScreenFont)
@property (nonatomic) IBInspectable float fixFont;
@end

@interface UIButton (FixScreenFont)
@property (nonatomic) IBInspectable float fixFont;
@end

@interface UITextField (FixScreenFont)
@property (nonatomic) IBInspectable float fixFont;
@end

@interface UITextView (FixScreenFont)
@property (nonatomic) IBInspectable float fixFont;
@end
