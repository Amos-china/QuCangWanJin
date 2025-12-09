#import "QCHBCashOutPageViewModel.h"
#import "AQService+CashOutPage.h"
#import "AQService+User.h"
#import "AQService+Complaint.h"
static NSString *const k_mmkv_show_show_qq_toast = @"k_mmkv_show_show_qq_toast";

@implementation QCHBCashOutPageViewModel

- (QCComplaintRootModel *)comlaintRootModel {
    if (!_comlaintRootModel) {
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"complaint_list" ofType:@"json"];
        NSError *error;
        NSData *jsonData = [NSData dataWithContentsOfFile:filePath options:0 error:&error];
        id json = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
        _comlaintRootModel = [QCComplaintRootModel modelWithkeyValues:json];
    }
    return _comlaintRootModel;
}

- (void)requestCashOutPage:(OnSuccess)success error:(QCHTTPRequestResponseErrorBlock)error {
    QCAdEcpmInfoModel *infoModel = [QCAdManager sharedInstance].splshAdEcpmInfo;
    __weak typeof(self) weakSelf = self;
    [QCService requestCashOutPage:infoModel.ecpm success:^(id  _Nonnull data) {
        weakSelf.cashOutPageModel = [QCHBCashOutPageModel modelWithkeyValues:data];
        QCUserInfoModel *userInfo = [QCUserModel getUserModel].user_info;
        userInfo.gold_money = weakSelf.cashOutPageModel.gold_money;
        [QCUserModel updateUserInfoModel:userInfo];
        success();
    } error:error];
}

- (NSString *)proportionText {
    return SF(@"%@元≈1元",self.cashOutPageModel.exchange_rate);
}

- (NSAttributedString *)ruleAtt {
    return [self.cashOutPageModel.rule setHtmlText];
}

- (NSAttributedString *)totalMoneyAtt {
    NSString *text = SF(@"%@元",self.cashOutPageModel.gold_money);
    return [text setMoneyFontAttMoneySize:44.f yuanSize:21.f];
}

- (NSAttributedString *)canCashWechatAtt {
    NSString *text = SF(@"可到账微信%@元",self.cashOutPageModel.can_tx_gold_money);
    return [text setRedTextAtt:self.cashOutPageModel.can_tx_gold_money];
}

- (NSString *)totalMoney {
    return SF(@"%@元",self.cashOutPageModel.gold_money);
}

- (NSString *)canCashMoney {
    return SF(@"%@元",self.cashOutPageModel.can_tx_gold_money);
}

- (NSInteger)getCanCashType {
    return [self checkMoneyType];
}

//0: 可提现 1: 需要完成任务  2:金额未达要求
- (NSInteger)checkMoneyType {
    float money = [self exchangeStringToFloatAt:self.cashOutPageModel.can_tx_gold_money];
    float minMoney = [self exchangeStringToFloatAt:self.cashOutPageModel.min_tx_money];
    if (money >= minMoney) {
        if (self.cashOutPageModel.gold_tx_lj_switch) {
            QCCommedHomeIndexModel *indexModel = [QCAdManager sharedInstance].commedHomeIndexModel;
            if (indexModel.ad_download_config.has_do_num) {
                return 0;
            }else {
                return 1;
            }
        }else {
            return 0;
        }
    }else {
        return 2;
    }
}

- (BOOL)answerCheckCanCash {
    float money = [self exchangeStringToFloatAt:self.cashOutPageModel.can_tx_gold_money];
    float minMoney = [self exchangeStringToFloatAt:self.cashOutPageModel.min_tx_money];
    return money >= minMoney;
}

- (float)exchangeStringToFloatAt:(NSString *)string {
    
    if (string.length == 0) {
        return 0;
    }
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [formatter setMaximumFractionDigits:2]; // 设置最多保留两位小数
    [formatter setRoundingMode:NSNumberFormatterRoundHalfUp]; // 四舍五入

    NSNumber *number = [formatter numberFromString:string];
    
    if (number) {
        return [number floatValue];
    } else {
        return 0;
    }
}

- (void)requestDoHBCashOut:(OnSuccess)success error:(QCHTTPRequestResponseErrorBlock)error {
    __weak typeof(self) weakSelf = self;
    [QCService requestDoHbCashOutSuccess:^(id  _Nonnull data) {
        weakSelf.cashlogModel = [QCWithrawalListModel modelWithkeyValues:data];
        if (weakSelf.cashlogModel.need_sm == 0) {
            QCUserInfoModel *userInfo = [QCUserModel getUserModel].user_info;
            userInfo.gold_money = @"0";
            [QCUserModel updateUserInfoModel:userInfo];
        }
        success();
    } error:error];
}

- (void)requestRealName:(NSString *)phone
                   name:(NSString *)name
                 idCard:(NSString *)idCard
                success:(OnSuccess)success
                  error:(QCHTTPRequestResponseErrorBlock)error {
    [QCService requestUserEqbAppprove:phone
                                        name:name
                                      idCard:idCard
                                     success:^(id  _Nonnull data) {
        !success ? :success();
    } error:error];
}

- (void)requestComplaintContent:(NSString *)content success:(OnSuccess)success error:(QCHTTPRequestResponseErrorBlock)error {
    [QCService requestComplaintTypeId:self.comlaintItemModel.complaintId
                                     content:content
                                     success:^(id  _Nonnull data) {
        !success ? :success();
    } error:error];
}

- (QCComplaintItemModel *)comlaintTableViewItem:(NSInteger)row {
    return self.comlaintRootModel.complaint_list[row];
}

- (NSInteger)complaintTableViewRows {
    return self.comlaintRootModel.complaint_list.count;
}

- (BOOL)canCashShowJoinQQController {
    if (self.cashOutPageModel.kf_config.kf_status) {
        if (self.cashOutPageModel.kf_config.cash_out_stop) {
            return [[MMKV defaultMMKV] getBoolForKey:k_mmkv_show_show_qq_toast defaultValue:YES];
        }
    }
    return NO;
}

- (void)setCashShowJoinQQControllerValue {
    [[MMKV defaultMMKV] setBool:NO forKey:k_mmkv_show_show_qq_toast];
}

- (BOOL)canShowTopJoinQQView {
    if (self.cashOutPageModel.kf_config.kf_status) {
        NSInteger cashOutNum = self.cashOutPageModel.kf_config.has_cash_out_num;
        NSInteger condition = self.cashOutPageModel.kf_config.condition;
        if (condition == 0) {
            return YES;
        }else {
            return cashOutNum - condition >= 0;
        }
    }
    return NO;
}

@end
