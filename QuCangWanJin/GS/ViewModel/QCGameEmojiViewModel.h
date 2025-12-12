//
//  QCGameEmojiViewModel.h
//  QuCangWanJin
//
//  Created by 陈志远 on 2025/12/12.
//

#import "QCBaseViewModel.h"
#import "QCGameEmojiModel.h"



NS_ASSUME_NONNULL_BEGIN

@interface QCGameEmojiViewModel : QCBaseViewModel


@property (nonatomic, assign) NSInteger selectIndex;
@property (nonatomic, copy) NSString *controllerLevelTitle;
@property (nonatomic, strong) QCGameEmojiModel *getCurrentLevelGameEmojiModel;
@property (nonatomic, copy) NSString *getCurrentPoints;
@property (nonatomic, copy) NSString *emojiImage;

- (BOOL)checkOptionIsRight;
- (NSString *)buttonTitleAtIndex:(NSInteger)index;
- (void)reset;
- (NSInteger)ider;
- (void)nextLevel;
- (void)changePointsWithRight:(BOOL)right;


@end

NS_ASSUME_NONNULL_END
