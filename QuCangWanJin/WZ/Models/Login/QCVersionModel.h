#import "QCBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface QCVersionModel : QCBaseModel

@property (nonatomic, assign) NSInteger force_update;
@property (nonatomic, copy) NSString *update_content;
@property (nonatomic, copy) NSString *version_num;
@property (nonatomic, copy) NSString *download_url;
@property (nonatomic, assign) NSInteger version_code;
@property (nonatomic, assign) NSInteger version_status;

@end

NS_ASSUME_NONNULL_END
