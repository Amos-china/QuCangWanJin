//
//  QCGameUserDataModel.m
//  QuCangWanJin
//
//  Created by 陈志远 on 2025/12/12.
//

#import "QCGameUserDataModel.h"

static NSString *const k_MMKV_GSB_GAME_USER_DATA_KEY = @"k_MMKV_GSB_GAME_USER_DATA_KEY";


@implementation QCGameUserDataModel

+ (QCGameUserDataModel *)getUserData {
    NSString *userDataJson = [[MMKV defaultMMKV] getStringForKey:k_MMKV_GSB_GAME_USER_DATA_KEY defaultValue:@""];
    if (userDataJson.length) {
        return [QCGameUserDataModel modelWithkeyValues:userDataJson];
    }else {
        QCGameUserDataModel *userDataModel = [[QCGameUserDataModel alloc] init];
        userDataModel.emojiLevelNum = 0;
        userDataModel.musicLevelNum = 0;
        userDataModel.points = 0;
        userDataModel.emojiMaxLevel = 29;
        userDataModel.musicMaxLevel = 99;
        userDataModel.musicGameUnlock = 0;
        return userDataModel;
    }
}

- (void)changeMusicLevelNum {
    self.musicLevelNum += 1;
    if (self.musicLevelNum == self.musicMaxLevel) {
        self.musicLevelNum = 0;
    }
    [self updateUserData];
}

- (void)changeEmojiLevelNum {
    self.emojiLevelNum += 1;
    if (self.emojiLevelNum == self.emojiMaxLevel) {
        self.emojiLevelNum = 0;
        self.musicGameUnlock = 1;
    }
    
    [self updateUserData];
}

- (void)changePointsWithRight:(BOOL)right {
    if (right) {
        self.points += 20;
    }else {
        self.points -= 10;
        self.points = self.points < 0 ? 0 : self.points;
    }
    [self updateUserData];
}

- (void)updateUserData {
    NSString *json = [self mj_JSONString];
    [[MMKV defaultMMKV] setString:json forKey:k_MMKV_GSB_GAME_USER_DATA_KEY];
}

@end
