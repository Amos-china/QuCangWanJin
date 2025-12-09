#import "QCHomeTopXJView.h"

@interface QCHomeTopXJView ()

@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *numLabel;

@end

@implementation QCHomeTopXJView


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

- (void)awakeFromNib {
    [super awakeFromNib];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapAction:)];
    [self addGestureRecognizer:tap];
}

- (void)updateView {
    QCUserModel *userModel = [QCUserModel getUserModel];
    CGFloat hbqMoney = [userModel.user_info.hbq_money floatValue];
    NSString *wxMoney = userModel.user_info.hbq_money;
    if (hbqMoney >= 10000) {
        hbqMoney = hbqMoney / 10000.00;
        wxMoney = SF(@"%.2f万",hbqMoney);
    }
    self.moneyLabel.text = SF(@"￥%@",wxMoney);

    
    QCGameCashConditionModel *conditionModel = [QCAdManager sharedInstance].conditionModel;
    if (conditionModel.condition_type == 1) {
        NSInteger gameNum = conditionModel.tgs_condition;
        self.numLabel.text = SF(@"通过%ld关可提现",gameNum);
    }else if (conditionModel.condition_type == 2) {
        CGFloat conditionValue = [conditionModel.condition_value floatValue];
        CGFloat showMoneyValue = conditionValue + hbqMoney;
        self.numLabel.text = SF(@"达到%.0f元可提现",showMoneyValue);
    }else {
        self.numLabel.text = @"可全部提现";
    }
}


- (void)viewTapAction:(UITapGestureRecognizer *)tap {
    !self.tapActionCallBack? : self.tapActionCallBack();
}

@end
