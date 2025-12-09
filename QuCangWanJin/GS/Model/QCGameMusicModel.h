#import "QCBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface QCGameMusicModel : QCBaseModel

@property (nonatomic, assign) NSInteger musicId;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSArray<NSString *> *options;
@property (nonatomic, assign) NSInteger answer;

@end

NS_ASSUME_NONNULL_END
