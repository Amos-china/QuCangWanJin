#import "QCAnswerButton.h"

@interface QCAnswerButton ()

@end

@implementation QCAnswerButton

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)drawRect:(CGRect)rect {
    
}

- (void)answerRight {
    [self configButton:YES];
}

- (void)answerWrong {
    [self configButton:NO];
}

- (void)configButton:(BOOL)right {
    NSString *buttonBackgroundImage = right ? @"home_cg_dt_dd_btn" : @"home_cg_dt_dc_btn";
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self setBackgroundImage:[UIImage imageNamed:buttonBackgroundImage] forState:UIControlStateNormal];
}

- (void)resetButton {
    [self setBackgroundImage:[UIImage imageNamed:@"home_cg_dt_mr_btn"] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}

@end
