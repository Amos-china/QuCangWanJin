#import "QCHomeTopHBView.h"

@interface QCHomeTopHBView ()

@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;

@end

@implementation QCHomeTopHBView


- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        UIView *view = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class])
                                                     owner:self
                                                   options:nil].firstObject;
        view.frame = self.bounds;
        [self addSubview:view];
    }
    return self;
}

- (void)updateView {
    QCUserModel *userModel = [QCUserModel getUserModel];
    self.moneyLabel.text = SF(@"%@元",userModel.user_info.gold_money);
}

- (IBAction)txButtonAction:(id)sender {
    !self.cashButtonCallBack? : self.cashButtonCallBack();
}


@end
