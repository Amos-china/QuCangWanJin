#import "QCGameIndexViewModel.h"

static NSString *const k_MMKV_GSB_GAME_INDEX_LEVEL_NUM_LEY = @"k_MMKV_GSB_GAME_INDEX_LEVEL_NUM_LEY";
static NSString *const k_MMKV_GSB_GAME_INDEX_POINTS_KEY = @"k_MMKV_GSB_GAME_INDEX_POINTS_KEY";

@interface QCGameIndexViewModel ()

@property (nonatomic, copy) NSArray<QCGameMusicModel *> *musicDataArr;
@property (nonatomic, assign) NSInteger levelNum;
@property (nonatomic, assign) NSInteger points;

@end

@implementation QCGameIndexViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.selectIndex = -1;
        self.levelNum = [[MMKV defaultMMKV] getInt32ForKey:k_MMKV_GSB_GAME_INDEX_LEVEL_NUM_LEY defaultValue:0];
        self.points = [[MMKV defaultMMKV] getInt32ForKey:k_MMKV_GSB_GAME_INDEX_POINTS_KEY defaultValue:0];
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
    return SF(@"第%ld关",self.levelNum + 1);
}

- (QCGameMusicModel *)getCurrentLevelGameMusicModel {
    return self.musicDataArr[self.levelNum];
}

- (NSString *)buttonTitleAtIndex:(NSInteger)index {
    return self.getCurrentLevelGameMusicModel.options[index];
}

- (BOOL)checkOptionIsRight {
    NSInteger rightKey = [self getCurrentLevelGameMusicModel].answer - 1;
    return self.selectIndex == rightKey;
}

- (NSString *)getCurrentPoints {
    return SF(@"%ld",self.points);
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
    self.levelNum ++;
    [[MMKV defaultMMKV] setInt32:(int32_t)self.levelNum forKey:k_MMKV_GSB_GAME_INDEX_LEVEL_NUM_LEY];
}

- (void)changePointsWithRight:(BOOL)right {
    if (right) {
        self.points += 20;
    }else {
        self.points -= 10;
        self.points = self.points < 0 ? 0 : self.points;
    }
    [[MMKV defaultMMKV] setInt32:(int32_t)self.points forKey:k_MMKV_GSB_GAME_INDEX_POINTS_KEY];
}

@end
