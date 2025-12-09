#import "QCBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface QCGroupMessageModel : QCBaseModel

@property (nonatomic, copy) NSString *time;
@property (nonatomic, assign) NSInteger groupId;
@property (nonatomic, copy) NSString *face;
@property (nonatomic, copy) NSString *nickname;
//0 群友消息 1 自己消息  2 红包消息 3 广告
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, copy) NSString *content;

@property (nonatomic, copy) NSString *messageId;
//领取状态
@property (nonatomic, assign) NSInteger collectStatus;

@property (nonatomic, strong) BUMCanvasView *adView;

@end

NS_ASSUME_NONNULL_END
