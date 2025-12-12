//
//  QCGameEmojiViewModel.m
//  QuCangWanJin
//
//  Created by 陈志远 on 2025/12/12.
//

#import "QCGameEmojiViewModel.h"
#import "QCGameUserDataModel.h"
@interface QCGameEmojiViewModel ()

@property (nonatomic, copy) NSArray<QCGameEmojiModel *> *gameArr;
@property (nonatomic, strong) QCGameUserDataModel *userDataModel;

@end

@implementation QCGameEmojiViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.userDataModel = [QCGameUserDataModel getUserData];
        [self loadData];
    }
    return self;
}

- (void)loadData {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"app_emoji_data" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
    self.gameArr = [QCGameEmojiModel mj_objectArrayWithKeyValuesArray:array];
}

- (NSString *)emojiImage {
    return self.getCurrentLevelGameEmojiModel.image;
}

- (NSString *)controllerLevelTitle {
    return SF(@"第%ld关",self.userDataModel.emojiLevelNum + 1);
}

- (QCGameEmojiModel *)getCurrentLevelGameEmojiModel {
    return self.gameArr[self.userDataModel.emojiLevelNum];
}

- (NSString *)buttonTitleAtIndex:(NSInteger)index {
    return self.getCurrentLevelGameEmojiModel.options[index];
}

- (BOOL)checkOptionIsRight {
    NSInteger rightKey = [self getCurrentLevelGameEmojiModel].correctIndex;
    return self.selectIndex == rightKey;
}

- (NSString *)getCurrentPoints {
    return SF(@"%ld",self.userDataModel.points);
}

- (void)reset {
    self.selectIndex = -1;
}

- (NSInteger)ider {
    self.selectIndex = self.getCurrentLevelGameEmojiModel.correctIndex;
    return self.selectIndex;
}

- (void)nextLevel {
    [self reset];
    [self.userDataModel changeEmojiLevelNum];
}

- (void)changePointsWithRight:(BOOL)right {
    [self.userDataModel changePointsWithRight:right];
}


@end
