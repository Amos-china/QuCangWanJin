#import "QCBaseViewModel.h"
#import "QCGameMusicModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface QCGameIndexViewModel : QCBaseViewModel

@property (nonatomic, assign) NSInteger selectIndex;
@property (nonatomic, copy) NSString *controllerLevelTitle;
@property (nonatomic, strong) QCGameMusicModel *getCurrentLevelGameMusicModel;
@property (nonatomic, copy) NSString *getCurrentPoints;


- (BOOL)checkOptionIsRight;
- (NSString *)buttonTitleAtIndex:(NSInteger)index;
- (void)reset;
- (NSInteger)ider;
- (void)nextLevel;
- (void)changePointsWithRight:(BOOL)right;

@end

NS_ASSUME_NONNULL_END
