#import "QCBaseViewModel.h"
#import "QCGroupMessageModel.h"
#import "QCCollectGoldModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface QCRedEnvelopeViewModel : QCBaseViewModel

@property (nonatomic, strong) NSIndexPath *selectIndexPath;
@property (nonatomic, strong) QCCollectGoldModel *collectGoldModel;

@property (nonatomic, strong) NSMutableArray<QCGroupMessageModel *> *msgList;

@property (nonatomic, assign) BOOL isCanSend;

- (QCGroupMessageModel *)getSelectMessageModel;

- (void)createData:(OnSuccess)success error:(QCHTTPRequestResponseErrorBlock)error;

- (void)requestAotuSendData;
- (BOOL)aotuSendMsgWithController:(UIViewController *)controller;
- (BOOL)sendMsg:(NSString *)content;

- (void)requestCollectTask:(NSInteger)task
                  ecpmInfo:(QCAdEcpmInfoModel *)ecpmInfo
                   success:(OnSuccess)success
                     error:(QCHTTPRequestResponseErrorBlock)error;


@end

NS_ASSUME_NONNULL_END
