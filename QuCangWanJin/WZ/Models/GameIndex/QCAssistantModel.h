#import "QCBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface QCAssistantModel : QCBaseModel

@property (nonatomic, copy) NSString *assistantId;
@property (nonatomic, copy) NSString *describe;
@property (nonatomic, copy) NSString *pic_thumb;
@property (nonatomic, copy) NSString *pic;
@property (nonatomic, assign) NSInteger unlock_need_levels;
//0: 未解锁 1:解锁了 2: 陪伴中 3: 待解锁
@property (nonatomic, assign) NSInteger state;
@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *assistant_pic;

@end

NS_ASSUME_NONNULL_END
