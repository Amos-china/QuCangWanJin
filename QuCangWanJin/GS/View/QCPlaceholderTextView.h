#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QCPlaceholderTextView : UITextView

@property (nonatomic, strong) IBInspectable NSString *placeholder;
@property (nonatomic, strong) IBInspectable UIColor *placeholderColor;
@property (nonatomic, strong) UIFont *placeholderFont;

@end

NS_ASSUME_NONNULL_END
