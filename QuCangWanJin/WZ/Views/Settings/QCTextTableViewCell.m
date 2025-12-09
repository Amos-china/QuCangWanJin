#import "QCTextTableViewCell.h"

@interface QCTextTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *despLabel;


@end

@implementation QCTextTableViewCell

- (void)setTextValue:(NSString *)textValue {
    _textValue = textValue;
    
    self.despLabel.text = textValue;
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
