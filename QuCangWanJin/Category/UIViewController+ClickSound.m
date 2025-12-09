//
//  UIViewController+ClickSound.m
//  MelonTheater
//
//  Created by 陈志远 on 2024/1/19.
//

#import "UIViewController+ClickSound.h"
#import <AudioToolbox/AudioToolbox.h>

@implementation UIViewController (ClickSound)

- (void)playShowPopuControllerSound {
    [self playSoundWithPathName:@"open_show"];
}

- (void)playSettlementSound {
    [self playSoundWithPathName:@"to_account"];
}

- (void)playTabbarItemClikSound {
    [self playSoundWithPathName:@"najianyin"];
}

- (void)playSoundWithPathName:(NSString *)pathName {
    NSString *path = [[NSBundle mainBundle] pathForResource:pathName ofType:@"mp3"];
    SystemSoundID soundID;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path], &soundID);
    AudioServicesPlaySystemSound(soundID);
}

- (void)playXuanDui {
    [self playSoundWithPathName:@"xuandui"];
}

- (void)playXuanCuo {
    [self playSoundWithPathName:@"xuancuo"];
}

- (void)playTanchuang {
    [self playSoundWithPathName:@"tanchutanchuang"];
}

- (void)playJinBiDaoZhang {
    [self playSoundWithPathName:@"jbdz"];
}

- (void)playBeiJingYinXiao {
    [self playSoundWithPathName:@"beijingyinxiao"];
}

- (void)playAnJianYin {
    [self playSoundWithPathName:@"anjianyin"];
}

- (void)playDaKaiHb {
    [self playSoundWithPathName:@"dkhb"];
}

- (void)playXiaoZhuLiGengHuan {
    [self playSoundWithPathName:@"xiaozhuligenghuan"];
}

- (void)playXingYunJiaYouBao {
    [self playSoundWithPathName:@"xingyunjiayoubao"];
}

- (void)playTiXiaoChengGong {
    [self playSoundWithPathName:@"tixianchenggong"];
}

- (void)playTongGuanQuanBuTiXian {
    [self playSoundWithPathName:@"tongguanquanbutixian"];
}


- (void)playGuessingSongSound:(BOOL)isRight {
    NSString *name = isRight ? @"cd" : @"cc";
    [self playSoundWithPathName:name];
}

- (void)playTouchButtonSound {
    [self playSoundWithPathName:@"anjianyin"];
}

- (void)playNewUserClearance {
    [self playSoundWithPathName:@"xsyd_tg"];
}

- (void)playKaiShiHengfu {
    [self playSoundWithPathName:@"kaishihengfu"];
}


- (void)playMeiNvLaiLe {
    [self playSoundWithPathName:@"meinvlaile"];
}


- (void)playNewUserClearanceHb {
    [self playSoundWithPathName:@"xsyd_tghb"];
}

- (void)playNewUserTx {
    [self playSoundWithPathName:@"xsyd_tx"];
}

- (void)playJBJZ {
    [self playSoundWithPathName:@"jbjz"];
}

- (void)playWXDZ {
    [self playSoundWithPathName:@"wxtxdz"];
}

- (void)playCGJL {
    [self playSoundWithPathName:@"cgjl"];
}

- (void)playCGJLXZL {
    [self playSoundWithPathName:@"cgjl_xzl"];
}

@end
