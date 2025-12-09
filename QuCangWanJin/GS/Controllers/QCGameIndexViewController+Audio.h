//
//  QCGameIndexViewController+Audio.h
//  QuCangWanJin
//
//  Created by 陈志远 on 2025/12/3.
//

#import "QCGameIndexViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface QCGameIndexViewController (Audio)


- (void)createSession;
- (void)playAudioWithURLString:(NSString *)name;

- (void)playerPlay;
- (void)playerPause;

@end

NS_ASSUME_NONNULL_END
