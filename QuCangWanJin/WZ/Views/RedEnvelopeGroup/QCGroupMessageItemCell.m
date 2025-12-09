#import "QCGroupMessageItemCell.h"

@interface QCGroupMessageItemCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconIM;
@property (weak, nonatomic) IBOutlet UILabel *nameLB;
@property (weak, nonatomic) IBOutlet UILabel *msgLB;
@property (weak, nonatomic) IBOutlet UIView *msgView;


@end

@implementation QCGroupMessageItemCell

- (void)setMsgModel:(QCGroupMessageModel *)msgModel {
    _msgModel = msgModel;
    
    [self.iconIM setImageWithURLString:msgModel.face];
    self.nameLB.text = msgModel.nickname;
    self.msgLB.text = msgModel.content;
    
    [self layoutIfNeeded];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.msgView.layer.cornerRadius = 10;
    self.msgView.layer.maskedCorners = kCALayerMaxXMinYCorner |  // 右上
                                      kCALayerMinXMaxYCorner |  // 左下
                                      kCALayerMaxXMaxYCorner;   // 右下
    self.msgView.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//- (void)layoutSubviews {
//    [super layoutSubviews];
//    
//    if (CGRectIsEmpty(self.msgView.bounds)) {
//        return;
//    }
//    
//    self.msgView.layer.cornerRadius = 10;
//    self.msgView.layer.maskedCorners = kCALayerMaxXMinYCorner |  // 右上
//                                      kCALayerMinXMaxYCorner |  // 左下
//                                      kCALayerMaxXMaxYCorner;   // 右下
//    self.msgView.layer.masksToBounds = YES;
//    
//    self.msgView.layer.mask = nil;
//}
//
//- (void)prepareForReuse {
//    [super prepareForReuse];
//    
//    self.msgView.layer.cornerRadius = 0;
//    self.msgView.layer.maskedCorners = 0;
//}


@end
