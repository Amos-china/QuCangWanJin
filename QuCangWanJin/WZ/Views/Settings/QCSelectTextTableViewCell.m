#import "QCSelectTextTableViewCell.h"

@interface QCSelectTextTableViewCell ()

@property (weak, nonatomic) IBOutlet UIButton *selectButton;
@property (weak, nonatomic) IBOutlet UILabel *despLabel;


@end

@implementation QCSelectTextTableViewCell

- (void)setModel:(QCUnRegisterModel *)model {
    _model = model;
    
    self.selectButton.selected = model.select;
    self.despLabel.text = model.title;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.selectButton setSelected:NO];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)selectButtonAction:(id)sender {
    self.selectButton.selected = !self.selectButton.selected;
    self.model.select = self.selectButton.selected;
}

@end
