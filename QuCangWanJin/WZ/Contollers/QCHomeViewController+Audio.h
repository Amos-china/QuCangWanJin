//
//  QCHomeViewController+Audio.h
//  QuCangWanJin
//
//  Created by 陈志远 on 2025/11/21.
//

#import "QCHomeViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface QCHomeViewController (Audio)

- (void)createSession;
- (void)playAudioWithURLString:(NSString *)name;

- (void)playerPlay;
- (void)playerPause;

@end

NS_ASSUME_NONNULL_END
