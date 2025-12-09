//
//  UIViewController+ClickSound.h
//  MelonTheater
//
//  Created by 陈志远 on 2024/1/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (ClickSound)

- (void)playShowPopuControllerSound;
- (void)playSettlementSound;
- (void)playTabbarItemClikSound;
- (void)playSoundWithPathName:(NSString *)pathName;


- (void)playXuanDui;
- (void)playXuanCuo;
- (void)playTanchuang;
- (void)playJinBiDaoZhang;
- (void)playBeiJingYinXiao;
- (void)playAnJianYin;
- (void)playTouchButtonSound;
- (void)playDaKaiHb;
- (void)playXiaoZhuLiGengHuan;
- (void)playXingYunJiaYouBao;
- (void)playTiXiaoChengGong;
- (void)playTongGuanQuanBuTiXian;
- (void)playKaiShiHengfu;
- (void)playMeiNvLaiLe;


@end

NS_ASSUME_NONNULL_END
