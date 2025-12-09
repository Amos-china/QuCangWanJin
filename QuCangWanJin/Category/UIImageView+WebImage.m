//
//  UIImageView+WebImage.m
//  MelonTheater
//
//  Created by 陈志远 on 2023/12/19.
//

#import "UIImageView+WebImage.h"

@implementation UIImageView (WebImage)

- (void)setImageWithURLString:(NSString *)url {
//    [self sd_setImageWithURL:[NSURL URLWithString:url]];
    __weak typeof(self) weakSelf = self;
    [self sd_setHighlightedImageWithURL:[NSURL URLWithString:url] options:SDWebImageAllowInvalidSSLCertificates completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if (image) {
            weakSelf.image = image;
        }
    }];
}

@end
