#import "QCAsisstantItemCell.h"

@interface QCAsisstantItemCell ()

@property (weak, nonatomic) IBOutlet UIImageView *streamerIM;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (weak, nonatomic) IBOutlet UIButton *nameBtn;
@property (weak, nonatomic) IBOutlet UILabel *numLB;
@property (weak, nonatomic) IBOutlet UIView *unlockView;

@end

@implementation QCAsisstantItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
   
    ViewRadius(self.streamerIM, 10.f);
    
    self.unlockView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5f];
}

- (void)setAssistantModel:(QCAssistantModel *)assistantModel {
    _assistantModel = assistantModel;
    [self.streamerIM setImageWithURLString:assistantModel.pic];
    [self.nameBtn setTitle:assistantModel.name forState:UIControlStateNormal];
    self.numLB.text = SF(@"还差%ld关解锁",assistantModel.unlock_need_levels);
    self.unlockView.hidden = assistantModel.state;
    self.selectBtn.hidden = assistantModel.state == 0;
    NSString *selectName = assistantModel.state == 1 ? @"选我吧" : @"已陪伴";
    NSString *selectImage = assistantModel.state == 1 ? @"zb_item_xwb" : @"zb_item_pbz";
    UIColor *titleColor = assistantModel.state == 1 ? [UIColor whiteColor] : AppColor;
    [self.selectBtn setTitle:selectName forState:UIControlStateNormal];
    [self.selectBtn setTitleColor:titleColor forState:UIControlStateNormal];
    [self.selectBtn setBackgroundImage:[UIImage imageNamed:selectImage] forState:UIControlStateNormal];
}

- (IBAction)selectButtonAction:(id)sender {
    if (self.assistantModel.state == 2) {
        return;
    }
    !self.selectButtonActionCallBack? :self.selectButtonActionCallBack(self.assistantModel);
}


@end
