//
//  QCFeedBackViewModel.h
//  QuCangWanJin
//
//  Created by 陈志远 on 2025/12/10.
//

#import "QCBaseViewModel.h"
#import "QCFeedBackRootModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^SelectSubmitTitleCallBack)(QCFeedBackItemModel *selectModel);

@interface QCFeedBackViewModel : QCBaseViewModel

@property (nonatomic, copy) SelectSubmitTitleCallBack callBack;

@property (nonatomic, copy) NSString *feedBackContent;

- (BOOL)checkItemModel;

- (NSInteger)tableViewRows;
- (QCFeedBackItemModel *)tableViewItemWithRow:(NSInteger)row;
- (void)tableViewSelectItemWithRow:(NSInteger)row;
- (void)selectImageWithBase64:(NSString *)base64;
- (void)deleteImage;

- (void)submitWithContent:(NSString *)content
                  success:(OnSuccess)success
                    error:(QCHTTPRequestResponseErrorBlock)error;

@end

NS_ASSUME_NONNULL_END
