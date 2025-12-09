#import "QCCashOutViewModel.h"
#import "AQService+CashOutPage.h"

@interface QCCashOutViewModel ()

@property (nonatomic, assign) NSInteger sendIndex;

@end

@implementation QCCashOutViewModel

- (NSMutableArray<QCXJDetailModel *> *)detailStatusArr {
    if (!_detailStatusArr) {
        _detailStatusArr = [NSMutableArray array];
    }
    return _detailStatusArr;
}

- (NSMutableArray<QCXJDetailModel *> *)listModels {
    if (!_listModels) {
        _listModels = [NSMutableArray array];
    }
    return _listModels;
}

- (void)requestXjCashOutPage:(OnSuccess)success
                       error:(QCHTTPRequestResponseErrorBlock)error {
    __weak typeof(self) weakSelf = self;
    [QCService requestXjCashOutPageSuccess:^(id  _Nonnull data) {
        weakSelf.cashOutIndexModel = [QCXJCashOutModel modelWithkeyValues:data];
        [QCUserModel updateUserInfoModel:weakSelf.cashOutIndexModel.user_info];
        weakSelf.sendIndex = weakSelf.sendIndex != 0 ? weakSelf.sendIndex : 0;
        success();
    } error:error];
}

- (NSAttributedString *)ruleAtt {
    return [self.cashOutIndexModel.rule setHtmlText];
}

- (NSString *)topNumText {
    return SF(@"通过第%ld关",self.cashOutIndexModel.withdrawal.game_num);
}

- (NSString *)bottomNumText {
    NSInteger gameNum = self.cashOutIndexModel.withdrawal.game_num;
    NSInteger stageNum = self.cashOutIndexModel.user_info.now_stage_num;
    if (stageNum > gameNum) {
        return @"已满足提现条件，点击提现！";
        
    }else {
        return SF(@"通过第%ld关可全额提现",self.cashOutIndexModel.withdrawal.game_num);
    }
}

- (NSString *)canCashMoneyText {
    return SF(@"%@元",self.cashOutIndexModel.withdrawal.tx_money);
}

- (BOOL)canCash {
    return self.cashOutIndexModel.withdrawal.can_tx != 0;
}

- (QCXJCashOutTxUserListModel *)sendUserCashDanma {
    if (self.cashOutIndexModel.tx_user_list.count == 0) {
        return nil;
    }
    
    if (self.sendIndex >= self.cashOutIndexModel.tx_user_list.count) {
        self.sendIndex = 0;
    }
    
    QCXJCashOutTxUserListModel *model = self.cashOutIndexModel.tx_user_list[self.sendIndex];
    self.sendIndex ++;
    return model;
}

//新人用户
- (void)requestDoXjCashOut:(OnSuccess)success error:(QCHTTPRequestResponseErrorBlock)error {
    __weak typeof(self) weakSelf = self;
    [QCService requestDoXjCashOutSuccess:^(id  _Nonnull data) {
        weakSelf.doCashLog = [QCWithrawalListModel modelWithkeyValues:data];
        QCUserInfoModel *userInfo = [QCUserModel getUserModel].user_info;
        userInfo.hbq_money = @"0";
        [QCUserModel updateUserInfoModel:userInfo];
        success();
    } error:error];
}

- (void)createDetailArr {
    [self.detailStatusArr removeAllObjects];
    [self.listModels removeAllObjects];
    
    QCXJDetailModel *tj1 = [[QCXJDetailModel alloc] init];
    tj1.title = @"发起提现申请";
    tj1.subTitle = @"";
    tj1.isShowDetail =  YES;
    tj1.status = 0;
    
    QCXJDetailModel *tj2 = [[QCXJDetailModel alloc] init];
    tj2.title = @"确认打款账户";
    tj2.subTitle = @"";
    tj2.isShowDetail = YES;
    tj2.status = 0;
    
    QCXJDetailModel *tj3 = [[QCXJDetailModel alloc] init];
    tj3.title = @"发起提现";
    tj3.subTitle = @"";
    tj3.isShowDetail = YES;
    tj3.status = 0;
    
    [self.detailStatusArr addObject:tj1];
    [self.detailStatusArr addObject:tj2];
    [self.detailStatusArr addObject:tj3];
    
    NSInteger conditionType = self.cashOutIndexModel.withdrawal.condition_type;
    
    if (conditionType == 1) {
        [self addClearanceConditions:NO];
    }else if (conditionType == 2) {
        [self addClearanceConditions:YES];
        [self addMoneyConditions:NO];
    }else if (conditionType == 3) {
        [self addClearanceConditions:YES];
        [self addMoneyConditions:YES];
        [self addAcitivConditions:NO];
    }else if (conditionType == 4) {
        [self addClearanceConditions:YES];
        [self addMoneyConditions:YES];
        [self addAcitivConditions:YES];
        [self addLevelConditions:NO];
    }else {
        [self addClearanceConditions:YES];
        [self addMoneyConditions:YES];
        [self addAcitivConditions:YES];
        [self addLevelConditions:YES];
    }
    
    QCXJDetailModel *tj5 = [[QCXJDetailModel alloc] init];
    tj5.title = @"提现成功到微信";
    tj5.subTitle = @"";
    tj5.status = 2;
    
    [self.detailStatusArr addObject:tj5];
    
    [self.listModels addObjectsFromArray:self.detailStatusArr];
    
    [self.detailStatusArr removeAllObjects];
}

- (void)addClearanceConditions:(BOOL)isMeet {
    [self.detailStatusArr addObject:[self clearanceConditions:isMeet]];
}

- (void)addMoneyConditions:(BOOL)isMeet {
    [self.detailStatusArr addObject:[self moneyConditions:isMeet]];
}

- (void)addAcitivConditions:(BOOL)isMeet {
    [self.detailStatusArr addObject:[self activiConditions:isMeet]];
}

- (void)addLevelConditions:(BOOL)isMeet {
    [self.detailStatusArr addObject:[self levelConditions:isMeet]];
}

- (QCXJDetailModel *)clearanceConditions:(BOOL)isMeet {
    QCXJDetailModel *model = [[QCXJDetailModel alloc] init];
    model.title = isMeet ? @"通关条件已满足" : @"通关条件未满足";
    model.subTitle = isMeet ? @"" : SF(@"还需要通过%ld关",self.cashOutIndexModel.withdrawal.tj.tj_a_1);
    model.isShowDetail = YES;
    model.status = isMeet ? 0 : 1;
    return model;
}

- (QCXJDetailModel *)moneyConditions:(BOOL)isMeet {
    NSString *minMoney = self.cashOutIndexModel.withdrawal.tj.tj_b_2;
    NSString *needMoney = self.cashOutIndexModel.withdrawal.tj.tj_b_1;
    NSString *subtitle = isMeet ? SF(@"现金余额满%@元,已打款至平台",minMoney) : SF(@"现金已打款至平台\n现金金额满%@元可到账,还差%@元",minMoney,needMoney);
    QCXJDetailModel *model = [[QCXJDetailModel alloc] init];
    model.title = @"已打款至平台";
    model.subTitle = subtitle;
    model.status = isMeet ? 0 : 1;
    model.isShowDetail = YES;
    model.toastText = SF(@"当前金额%@元,还差%@元",self.cashOutIndexModel.withdrawal.tx_money,needMoney);
    return model;
}

- (QCXJDetailModel *)activiConditions:(BOOL)isMeet {
    NSInteger loginNum = self.cashOutIndexModel.withdrawal.tj.tj_c_1;
    NSInteger needLoginNum = self.cashOutIndexModel.withdrawal.tj.tj_c_2;
    NSInteger activiNum = self.cashOutIndexModel.withdrawal.tj.tj_c_3;
    NSInteger needActiviNum = self.cashOutIndexModel.withdrawal.tj.tj_c_4;
    NSString *loginText = SF(@"【已登录天数】：%ld/%ld天",loginNum,needLoginNum);
    NSString *activText = SF(@"【今日通关数】：%ld/%ld关",activiNum,needActiviNum);
    NSString *subtitle = SF(@"%@\n%@",loginText,activText);
    QCXJDetailModel *model = [[QCXJDetailModel alloc] init];
    model.title = isMeet ? @"活跃度已完成" : @"活跃度未完成";
    model.subTitle = subtitle;
    model.status = isMeet ? 0 : 1;
    model.isShowDetail = YES;
    model.toastText = model.subTitle;
    return model;
}

- (QCXJDetailModel *)levelConditions:(BOOL)isMeet {
    NSInteger level = self.cashOutIndexModel.withdrawal.tj.tj_d_1;
    NSInteger needLevel = self.cashOutIndexModel.withdrawal.tj.tj_d_2;
    QCXJDetailModel *model = [[QCXJDetailModel alloc] init];
    model.title = isMeet ? @"已达提现等级" : SF(@"等级不够,需等级达到%ld级",needLevel);
    model.subTitle = SF(@"【当前等级】:%ld级",level);
    model.status = isMeet ? 0 : 1;
    model.isShowDetail = YES;
    model.toastText = model.subTitle;
    return model;
}

- (void)requstAddFaqiLog:(OnSuccess)success error:(QCHTTPRequestResponseErrorBlock)error {
    __weak typeof(self) weakSelf = self;
    [QCService requestAddXjtxFaqiLog:self.cashOutIndexModel.withdrawal.config_id
                                    success:^(id  _Nonnull data) {
        weakSelf.doCashLog = [QCWithrawalListModel modelWithkeyValues:data];
//        weakSelf.cashOutIndexModel.withdrawal.tx_condition = weakSelf.doCashLog.tx_condition;
//        weakSelf.cashOutIndexModel.withdrawal.line_up_num = weakSelf.doCashLog.line_up_num;
//        weakSelf.cashOutIndexModel.withdrawal.tg_rate = weakSelf.doCashLog.tg_rate;
//        weakSelf.cashOutIndexModel.withdrawal.tx_money = weakSelf.doCashLog.tx_money;
//        weakSelf.cashOutIndexModel.withdrawal.condition_type = weakSelf.doCashLog.condition_type;
//        weakSelf.cashOutIndexModel.withdrawal.tj = weakSelf.doCashLog.tj;
//        AQUserInfoModel *userInfo = [AQUserModel getUserModel].user_info;
//        userInfo.hbq_money = @"0";
//        [AQUserModel updateUserInfoModel:userInfo];
        success();
    } error:error];
}

- (void)requestJiaYouBaoSuccess:(OnSuccess)success error:(QCHTTPRequestResponseErrorBlock)error {
    __weak typeof(self) weakSelf = self;
    [QCService requestGetJiaYouBaoSuccess:^(id  _Nonnull data) {
        weakSelf.luckyModel = [QCWithrawalLuckyModel modelWithkeyValues:data];
        weakSelf.cashOutIndexModel.withdrawal.can_tx = 3;
//        [weakSelf postNotification];
        [QCAdManager sharedInstance].conditionModel = weakSelf.luckyModel.xjtx_condition;
        [QCAdManager sharedInstance].conditionModel.xjtx_page = 2;
        success();
    } error:error];
}

- (void)postNotification {
    NSDictionary *userInfo = [self.luckyModel.xjtx_condition mj_keyValues];
    [[NSNotificationCenter defaultCenter] postNotificationName:k_UPDATE_LUCKY_MONEY_NOTICE object:nil userInfo:userInfo];
}

- (void)updateTableViewCell {
    QCXJDetailModel *moneyModel = [self moneyConditions:NO];
    self.detailStatusArr[4] = moneyModel;
}

@end
