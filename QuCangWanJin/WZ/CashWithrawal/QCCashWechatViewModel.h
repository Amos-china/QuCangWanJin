#import "QCBaseViewModel.h"
#import "QCCashWechatModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^CashWechatSuccessCompletion)(QCCashWechatModel *);

@interface QCCashWechatViewModel : QCBaseViewModel


@property (nonatomic, assign) BOOL isEnterBackground;
@property (nonatomic, assign) BOOL isClickAd;
@property (nonatomic, assign) BOOL isShowAd;
@property (nonatomic, assign) NSInteger lookTime;
@property (nonatomic, assign) NSTimeInterval expectedTime;

- (void)requestCashWechat:(QCAdEcpmInfoModel *)ecpmInfo
                  success:(CashWechatSuccessCompletion)success
                    error:(QCHTTPRequestResponseErrorBlock)error;

- (void)reset;

@end

NS_ASSUME_NONNULL_END
