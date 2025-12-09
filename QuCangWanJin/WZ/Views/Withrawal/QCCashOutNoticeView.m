#import "QCCashOutNoticeView.h"

@interface QCCashOutNoticeView ()

@property (weak, nonatomic) IBOutlet UILabel *msgLabel;

@end

@implementation QCCashOutNoticeView

- (void)setMoney:(NSString *)money {
    _money = money;
    NSString *moneyStr = SF(@"%@元",money);
    NSString *message = SF(@"%@已到微信，请查收",moneyStr);
    
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:message];
    att.yy_font = APPFONT(16.f);
    att.yy_color = [UIColor blackColor];
    NSRange range = [message rangeOfString:moneyStr];
    [att addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#FF3B30"] range:range];
    self.msgLabel.attributedText = att;
}


@end
