#import "QCLoadingImageView.h"

@interface QCLoadingImageView ()

@property (nonatomic, strong) UIImageView *loadImageView;

@end

@implementation QCLoadingImageView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.image = [UIImage imageNamed:@"withdrawal_lg_im"];
    UIImage *jz_image = [UIImage imageNamed:@"tx_wx_jz_im"];
    CGRect jz_rect = CGRectMake(self.image.size.width / 2, self.image.size.height / 2, jz_image.size.width, jz_image.size.height);
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:jz_rect];
    imageView.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    imageView.image = jz_image;
    self.loadImageView = imageView;

    
    [self addSubview:self.loadImageView];
    
    [self.loadImageView viewNonstopRotationAnimation];
}

- (void)setLoadingStatus:(AQLoadingImageViewStatus)loadingStatus {
    _loadingStatus = loadingStatus;
    
    NSString *imageName = @"withdrawal_lg_im";
    switch (loadingStatus) {
        case GSLoadingImageViewStatusNormal:
            imageName = @"withdrawal_lg_im";
            self.loadImageView.hidden = YES;
            break;
        case GSLoadingImageViewStatusLoading:
            imageName = @"tx_wx_cs_im";
            self.loadImageView.hidden = NO;
            break;
        case GSLoadingImageViewStatusGray:
            imageName = @"withdrawal_hs_gou_im";
            self.loadImageView.hidden = YES;
            break;
        default:
            break;
    }
    
    self.image = [UIImage imageNamed:imageName];
}

@end
