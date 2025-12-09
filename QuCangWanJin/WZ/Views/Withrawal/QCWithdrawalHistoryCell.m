#import "QCWithdrawalHistoryCell.h"

@interface QCWithdrawalHistoryCell ()

@property (weak, nonatomic) IBOutlet UILabel *statusLB;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *statusButton;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;


@end

@implementation QCWithdrawalHistoryCell


- (void)setLogModel:(QCCashOutGetLogModel *)logModel {
    _logModel = logModel;
    
    self.statusLB.text = [self getCashType:logModel.type];
    self.timeLabel.text = logModel.data_time;
    self.moneyLabel.text = SF(@"%@元",logModel.money);
    
    NSString *status = [self getCashStatus:logModel.status];
    [self.statusButton setTitle:status forState:UIControlStateNormal];
    
    NSString *imageName = logModel.status == 1 ? @"txjl-icon1" : @"txjl-icon2";
    [self.statusButton setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
}

- (NSString *)getCashStatus:(NSInteger)status {
    switch (status) {
        case 1:
            return @"已到账";
        case 2:
            return @"待审核";
        case 5:
            return @"提现中";
        default:
            return SF(@"未知状态:%ld",status);
    }
}

- (NSString *)getCashType:(NSInteger)type {
    switch (type) {
        case 1:
            return @"红包提现";
        case 2:
            return @"现金提现";
        case 4:
            return @"每日提现";
        case 5:
            return @"福利中心提现（元宝)";
        case 6:
            return @"现金红包提现";
        default:
            return SF(@"未知类型:%ld",type);
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
