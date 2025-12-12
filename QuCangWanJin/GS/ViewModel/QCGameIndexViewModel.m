#import "QCGameIndexViewModel.h"
#import "QCGameUserDataModel.h"
@interface QCGameIndexViewModel ()

@property (nonatomic, copy) NSArray<QCGameMusicModel *> *musicDataArr;
@property (nonatomic, strong) QCGameUserDataModel *userDataModel;

@end

@implementation QCGameIndexViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.selectIndex = -1;
        self.userDataModel = [QCGameUserDataModel getUserData];
        [self loadMusicJsonFile];
    }
    return self;
}



- (void)loadMusicJsonFile {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"app_data" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
    self.musicDataArr = [QCGameMusicModel mj_objectArrayWithKeyValuesArray:array];
}

- (NSString *)controllerLevelTitle {
    return SF(@"第%ld关",self.userDataModel.musicLevelNum + 1);
}

- (QCGameMusicModel *)getCurrentLevelGameMusicModel {
    return self.musicDataArr[self.userDataModel.musicLevelNum];
}

- (NSString *)buttonTitleAtIndex:(NSInteger)index {
    return self.getCurrentLevelGameMusicModel.options[index];
}

- (BOOL)checkOptionIsRight {
    NSInteger rightKey = [self getCurrentLevelGameMusicModel].answer - 1;
    return self.selectIndex == rightKey;
}

- (NSString *)getCurrentPoints {
    return SF(@"%ld",self.userDataModel.points);
}

- (void)reset {
    self.selectIndex = -1;
}

- (NSInteger)ider {
    self.selectIndex = self.getCurrentLevelGameMusicModel.answer - 1;
    return self.selectIndex;
}

- (void)nextLevel {
    [self reset];
    [self.userDataModel changeMusicLevelNum];
}

- (void)changePointsWithRight:(BOOL)right {
    [self.userDataModel changePointsWithRight:right];
}

@end
