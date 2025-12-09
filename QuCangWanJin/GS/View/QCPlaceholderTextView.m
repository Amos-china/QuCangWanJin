#import "QCPlaceholderTextView.h"

@interface QCPlaceholderTextView ()

@property (nonatomic, strong) UILabel *placeholderLabel;


@end

@implementation QCPlaceholderTextView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    // 创建placeholder标签
    _placeholderLabel = [[UILabel alloc] init];
    _placeholderLabel.numberOfLines = 0;
    _placeholderLabel.textColor = [UIColor lightGrayColor];
    _placeholderLabel.font = self.font;
    _placeholderLabel.backgroundColor = [UIColor clearColor];
    _placeholderLabel.userInteractionEnabled = NO;
    [self addSubview:_placeholderLabel];
    
    // 设置默认值
    _placeholder = @"";
    _placeholderColor = [UIColor lightGrayColor];
    
    // 监听文本变化
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textDidChange:)
                                                 name:UITextViewTextDidChangeNotification
                                               object:self];
    
    // 初始更新
    [self updatePlaceholder];
}

#pragma mark - Layout

- (void)layoutSubviews {
    [super layoutSubviews];
    [self updatePlaceholderLabelFrame];
}

- (void)updatePlaceholderLabelFrame {
    // 计算placeholder的frame，考虑textContainer的inset
    CGFloat lineFragmentPadding = self.textContainer.lineFragmentPadding;
    UIEdgeInsets textContainerInset = self.textContainerInset;
    
    CGFloat x = lineFragmentPadding + textContainerInset.left;
    CGFloat y = textContainerInset.top;
    CGFloat width = CGRectGetWidth(self.bounds) - x - lineFragmentPadding - textContainerInset.right;
    CGFloat height = [self.placeholderLabel sizeThatFits:CGSizeMake(width, CGFLOAT_MAX)].height;
    
    self.placeholderLabel.frame = CGRectMake(x, y, width, height);
}

#pragma mark - Text Change Notification

- (void)textDidChange:(NSNotification *)notification {
    [self updatePlaceholder];
}

- (void)updatePlaceholder {
    self.placeholderLabel.hidden = self.text.length > 0;
}

#pragma mark - Setters

- (void)setPlaceholder:(NSString *)placeholder {
    _placeholder = placeholder;
    self.placeholderLabel.text = placeholder;
    [self updatePlaceholderLabelFrame];
    [self updatePlaceholder];
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor {
    _placeholderColor = placeholderColor;
    self.placeholderLabel.textColor = placeholderColor;
}

- (void)setFont:(UIFont *)font {
    [super setFont:font];
    self.placeholderLabel.font = font;
    [self updatePlaceholderLabelFrame];
}

- (void)setText:(NSString *)text {
    [super setText:text];
    [self updatePlaceholder];
}

- (void)setAttributedText:(NSAttributedString *)attributedText {
    [super setAttributedText:attributedText];
    [self updatePlaceholder];
}

- (void)setTextContainerInset:(UIEdgeInsets)textContainerInset {
    [super setTextContainerInset:textContainerInset];
    [self updatePlaceholderLabelFrame];
}

#pragma mark - Dealloc

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
