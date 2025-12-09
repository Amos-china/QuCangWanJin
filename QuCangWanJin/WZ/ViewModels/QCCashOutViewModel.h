#import "QCBaseViewModel.h"
#import "QCXJCashOutModel.h"
#import "QCXJDetailModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface QCCashOutViewModel : QCBaseViewModel

@property (nonatomic, strong) QCWithrawalLuckyModel *luckyModel;
@property (nonatomic, strong) QCXJCashOutModel *cashOutIndexModel;
@property (nonatomic, strong) QCWithrawalListModel *doCashLog;
@property (nonatomic, copy) NSAttributedString *ruleAtt;
@property (nonatomic, assign) BOOL canCash;

@property (nonatomic, copy) NSString *topNumText;
@property (nonatomic, copy) NSString *bottomNumText;
@property (nonatomic, copy) NSString *canCashMoneyText;

@property (nonatomic, strong) NSMutableArray<QCXJDetailModel *> *detailStatusArr;
@property (nonatomic, strong) NSMutableArray<QCXJDetailModel *> *listModels;
- (void)createDetailArr;

- (QCXJCashOutTxUserListModel *)sendUserCashDanma;

- (void)requestXjCashOutPage:(OnSuccess)success
                       error:(QCHTTPRequestResponseErrorBlock)error;

- (void)requestDoXjCashOut:(OnSuccess)success error:(QCHTTPRequestResponseErrorBlock)error;
- (void)requstAddFaqiLog:(OnSuccess)success error:(QCHTTPRequestResponseErrorBlock)error;
- (void)requestJiaYouBaoSuccess:(OnSuccess)success error:(QCHTTPRequestResponseErrorBlock)error;

- (QCXJDetailModel *)clearanceConditions:(BOOL)isMeet;
- (QCXJDetailModel *)moneyConditions:(BOOL)isMeet;
- (QCXJDetailModel *)activiConditions:(BOOL)isMeet;
- (QCXJDetailModel *)levelConditions:(BOOL)isMeet;

- (void)updateTableViewCell;

@end

NS_ASSUME_NONNULL_END
