//
//  QCGameEmojiModel.h
//  QuCangWanJin
//
//  Created by 陈志远 on 2025/12/12.
//

#import "QCBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface QCGameEmojiModel : QCBaseModel

@property (nonatomic, copy) NSString *image;
@property (nonatomic, copy) NSString *answer;
@property (nonatomic, copy) NSArray<NSString *> *options;
@property (nonatomic, assign) NSInteger correctIndex;

@end

NS_ASSUME_NONNULL_END
