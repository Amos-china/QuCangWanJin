#import "QCBaseViewModel.h"
#import "QCHBCashOutPageModel.h"
#import "QCWithrawalListModel.h"
#import "QCComplaintRootModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface QCHBCashOutPageViewModel : QCBaseViewModel

@property (nonatomic, strong) QCHBCashOutPageModel *cashOutPageModel;

@property (nonatomic, copy) NSString *proportionText;
@property (nonatomic, copy) NSAttributedString *ruleAtt;
@property (nonatomic, copy) NSAttributedString *totalMoneyAtt;
@property (nonatomic, copy) NSAttributedString *canCashWechatAtt;

@property (nonatomic, copy) NSString *totalMoney;
@property (nonatomic, copy) NSString *canCashMoney;

- (void)requestCashOutPage:(OnSuccess)success error:(QCHTTPRequestResponseErrorBlock)error;

//0:可提现  1:未完成提现  2:金额未达到要求
- (NSInteger)getCanCashType;
- (BOOL)answerCheckCanCash;

@property (nonatomic, strong) QCWithrawalListModel *cashlogModel;

- (void)requestDoHBCashOut:(OnSuccess)success error:(QCHTTPRequestResponseErrorBlock)error;

- (void)requestRealName:(NSString *)phone
                   name:(NSString *)name
                 idCard:(NSString *)idCard
                success:(OnSuccess)success
                  error:(QCHTTPRequestResponseErrorBlock)error;


//投诉建议
@property (nonatomic, strong) QCComplaintRootModel *comlaintRootModel;
@property (nonatomic, strong) QCComplaintItemModel *comlaintItemModel;

- (void)requestComplaintContent:(NSString *)content success:(OnSuccess)success error:(QCHTTPRequestResponseErrorBlock)error;

- (QCComplaintItemModel *)comlaintTableViewItem:(NSInteger)row;
- (NSInteger)complaintTableViewRows;

- (BOOL)canShowTopJoinQQView;
- (BOOL)canCashShowJoinQQController;
- (void)setCashShowJoinQQControllerValue;

@end

NS_ASSUME_NONNULL_END
