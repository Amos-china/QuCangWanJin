//
//  SDAnimatedImageView+Anidmated.m
//  AnswerQuestions
//
//  Created by 陈志远 on 2025/9/24.
//

#import "SDAnimatedImageView+Anidmated.h"

@implementation SDAnimatedImageView (Anidmated)

- (void)displayLocalGIFWithImageName:(NSString *)imageName {
    // 获取本地 GIF 文件路径
    NSString *filePath = [[NSBundle mainBundle] pathForResource:imageName ofType:@"gif"];
    NSData *gifData = [NSData dataWithContentsOfFile:filePath];
    
    // 创建 SDAnimatedImage
    SDAnimatedImage *animatedImage = [[SDAnimatedImage alloc] initWithData:gifData];
    
    // 设置到 SDAnimatedImageView
    [self sd_setImageWithURL:[NSURL fileURLWithPath:filePath]];
}

@end
