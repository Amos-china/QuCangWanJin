#import "QCXJDetailStatusCell.h"

@interface QCXJDetailStatusCell ()

@property (weak, nonatomic) IBOutlet UIImageView *statusIM;
@property (weak, nonatomic) IBOutlet UILabel *titleLB;


@end

@implementation QCXJDetailStatusCell

- (void)setModel:(QCXJDetailModel *)model {
    _model = model;
    
    self.titleLB.text = model.title;
    
    NSString *imageName = @"xj-icon1";
    if (model.status == 0) {
        imageName = @"xj-icon1";
    }else if (model.status == 1) {
        imageName = @"xj-icon2";
    }else {
        imageName = @"xj-icon3";
    }
    
    self.statusIM.image = [UIImage imageNamed:imageName];
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
