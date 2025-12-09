#import "QCGroupHBItemCell.h"

@interface QCGroupHBItemCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconIM;
@property (weak, nonatomic) IBOutlet UILabel *nameLB;
@property (weak, nonatomic) IBOutlet UIButton *hbButton;


@end

@implementation QCGroupHBItemCell

- (void)setMsgModel:(QCGroupMessageModel *)msgModel {
    _msgModel = msgModel;
    
    [self.iconIM setImageWithURLString:msgModel.face];
    self.nameLB.text = msgModel.nickname;
    
    NSString *btnImage = msgModel.collectStatus ? @"hbq-rec3" : @"hbq-hb-item";
    [self.hbButton setImage:[UIImage imageNamed:btnImage] forState:UIControlStateNormal];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)hbButtonAction:(id)sender {
    if (!self.msgModel.collectStatus) {
        !self.buttonActionCallBack? :self.buttonActionCallBack(self.msgModel);
    }
}

@end
