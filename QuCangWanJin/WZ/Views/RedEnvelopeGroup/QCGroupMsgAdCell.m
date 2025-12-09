#import "QCGroupMsgAdCell.h"

@interface QCGroupMsgAdCell ()

@property (weak, nonatomic) IBOutlet UIView *showAdView;

@end

@implementation QCGroupMsgAdCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setMsgModel:(QCGroupMessageModel *)msgModel {
    _msgModel = msgModel;
    
    for (UIView *view in self.showAdView.subviews) {
        BOOL show = [view isKindOfClass:BUMCanvasView.class];
        if (show) {
            [view removeFromSuperview];
        }
    }
    
    [self.showAdView addSubview:self.msgModel.adView];
    
    [self.showAdView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(_msgModel.adView.frame.size.height);
    }];
    [self layoutIfNeeded];
}

@end
