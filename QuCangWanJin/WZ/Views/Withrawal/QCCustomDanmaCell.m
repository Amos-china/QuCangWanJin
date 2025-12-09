#import "QCCustomDanmaCell.h"

@interface QCCustomDanmaCell ()

@property (nonatomic, strong) UIView *coverView;
@property (nonatomic, strong) UIImageView *userImageView;
@property (nonatomic, strong) UILabel *contentLabel;

@end

@implementation QCCustomDanmaCell

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = HJDanmakuCellSelectionStyleNone;
    }
    return self;
}

- (void)prepareForReuse {
    
}

- (void)setDanmaModel:(QCDanmaModel *)danmaModel {
    _danmaModel = danmaModel;
    
    [self.userImageView setImageWithURLString:danmaModel.url];
    self.contentLabel.attributedText = danmaModel.att;
    [self layoutIfNeeded];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    ViewRadius(self.coverView, 15.f);
    self.coverView.backgroundColor = [UIColor colorWithHexString:@"#F4E6D2"];
    self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0];
    
    self.userImageView.frame = CGRectMake(14.f, 6.f, 18.f, 18.f);
    self.contentLabel.frame = CGRectMake(40.f, 0, self.bounds.size.width - 28.f - 18.f - 8.f, 30.f);
    self.coverView.frame = CGRectMake(0, 5.f, self.bounds.size.width, 30.f);
}

- (UIImageView *)userImageView {
    if (!_userImageView) {
        _userImageView = [[UIImageView alloc] init];
        _userImageView.frame = CGRectMake(14.f, 6.f, 18.f, 18.f);
        _userImageView.layer.cornerRadius = 9.f;
        _userImageView.layer.masksToBounds = YES;
        [self.coverView addSubview:_userImageView];
    }
    return _userImageView;
}

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.frame = CGRectMake(32.f, 0, self.bounds.size.width - 28.f - 18.f - 8.f, 30.f);
        _contentLabel.font = APPFONT(14.f);
        [self.coverView addSubview:_contentLabel];
    }
    return _contentLabel;
}

- (UIView *)coverView {
    if (!_coverView) {
        _coverView = [[UIView alloc] initWithFrame:CGRectMake(0, 5.f, self.bounds.size.width, 30.f)];
        [self addSubview:_coverView];
    }
    return _coverView;
}

@end
