//
//  QCGameUserDataModel.h
//  QuCangWanJin
//
//  Created by 陈志远 on 2025/12/12.
//

#import "QCBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface QCGameUserDataModel : QCBaseModel

@property (nonatomic, assign) NSInteger emojiMaxLevel;
@property (nonatomic, assign) NSInteger musicMaxLevel;
@property (nonatomic, assign) NSInteger musicLevelNum;
@property (nonatomic, assign) NSInteger emojiLevelNum;
@property (nonatomic, assign) NSInteger points;
@property (nonatomic, assign) NSInteger musicGameUnlock;

+ (QCGameUserDataModel *)getUserData;
- (void)changeMusicLevelNum;
- (void)changeEmojiLevelNum;
- (void)changePointsWithRight:(BOOL)right;

@end

NS_ASSUME_NONNULL_END
