//
//  QCGameIndexViewController+Audio.m
//  QuCangWanJin
//
//  Created by 陈志远 on 2025/12/3.
//

#import "QCGameIndexViewController+Audio.h"

@implementation QCGameIndexViewController (Audio)

- (void)createSession {
    AVAudioSession *session = [AVAudioSession sharedInstance];
    NSError *sessionError;
    [session setCategory:AVAudioSessionCategoryPlayback error:&sessionError];
    if (sessionError) {
        NSLog(@"音频会话配置失败: %@", sessionError.localizedDescription);
        return;
    }
    [session setActive:YES error:nil];
}


- (void)playAudioWithURLString:(NSString *)name {
    
    // 停止当前播放
    if (self.audioPlayer) {
        [self.audioPlayer stop];
        self.audioPlayer = nil;
    }

    NSURL *url = [NSURL URLWithString:name];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            [self showToast:@"音频文件下载出错"];
            return;
        }
        
        if (!data) {
            [self showToast:@"音频文件下载错误"];
            return;
        }
        
        // 在主线程初始化 AVAudioPlayer
        dispatch_async(dispatch_get_main_queue(), ^{
            NSError *playerError = nil;
            self.audioPlayer = [[AVAudioPlayer alloc] initWithData:data error:&playerError];
            if (playerError) {
                NSLog(@"初始化 AVAudioPlayer 失败: %@", playerError.localizedDescription);
                return;
            }
            
            // 设置播放器属性
            self.audioPlayer.numberOfLoops = -1; // 0 表示播放一次，-1 表示循环
            self.audioPlayer.volume = 1.0; // 音量范围 0.0 到 1.0
            
            // 准备播放
            [self.audioPlayer prepareToPlay];
            
            // 自动播放
            [self.audioPlayer play];
            
        });
    }];
    
    [dataTask resume];
}

- (void)playerPlay {
    if (self.audioPlayer) {
        if (!self.audioPlayer.playing) {
            [self.audioPlayer play];
        }
    }
}

- (void)playerPause {
    if (self.audioPlayer) {
        [self.audioPlayer pause];
    }
}



@end
