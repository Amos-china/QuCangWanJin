#import "QCXJDetailSubTileCell.h"

@interface QCXJDetailSubTileCell ()

@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *lineIM;

@end

@implementation QCXJDetailSubTileCell

- (void)setModel:(QCXJDetailModel *)model {
    _model = model;
    
    self.subTitleLabel.text = model.subTitle;
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
