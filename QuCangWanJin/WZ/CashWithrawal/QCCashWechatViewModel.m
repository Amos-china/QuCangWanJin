#import "QCCashWechatViewModel.h"
#import "AQService+Task.h"


@implementation QCCashWechatViewModel


- (instancetype)init {
    if (self = [super init]) {
        [self reset];
    }
    return self;
}

- (void)reset {
    self.lookTime = 0;
    self.isEnterBackground = NO;
    self.isShowAd = NO;
    self.isClickAd = NO;
    self.expectedTime = 0;
}

- (void)requestCashWechat:(QCAdEcpmInfoModel *)ecpmInfo
                  success:(CashWechatSuccessCompletion)success
                    error:(QCHTTPRequestResponseErrorBlock)error {
    NSString *userId = [QCUserModel getUserModel].user_info.user_id;
    [QCService requestCashWechat:userId
                                   ecpm:ecpmInfo.ecpm
                                 adType:ecpmInfo.adType
                              plateCode:ecpmInfo.plateCode
                                success:^(id  _Nonnull data) {
        QCCashWechatModel *cashModel = [QCCashWechatModel modelWithkeyValues:data];
        !success ? : success(cashModel);
    } error:error];
}

@end
