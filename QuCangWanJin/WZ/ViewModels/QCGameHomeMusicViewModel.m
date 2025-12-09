#import "QCGameHomeMusicViewModel.h"
#import "AQService+Game.h"

static NSString *const k_mmkv_show_xs = @"k_mmkv_show_xs";
static NSString *const k_mmkv_collect_min_num = @"k_mmkv_collect_min_num";

@interface QCGameHomeMusicViewModel ()

@property (nonatomic, assign) NSInteger collectMinGoldNum;
@property (nonatomic, assign) BOOL showGuideRequestLog;
@property (nonatomic, assign) NSInteger cashMaxTime;
@property (nonatomic, strong) dispatch_source_t timer;
@property (nonatomic, assign) BOOL canCashHb;
@property (nonatomic, assign) NSInteger lookVideoNum;
@property (nonatomic, assign) BOOL isShowSecondToast;

@end

@implementation QCGameHomeMusicViewModel

- (instancetype)init {
    if (self = [super init]) {
        self.collectMinGoldNum = [[MMKV defaultMMKV] getInt32ForKey:k_mmkv_collect_min_num defaultValue:0];
        self.showGuideRequestLog = YES;
        self.cashMaxTime = 300;
        self.canCashHb = YES;
        [self getLookVideoNumAtMMKV];
    }
    return self;
}

- (void)setUpCollectionMum:(NSInteger)num {
    NSLog(@"……%ld",num);
    [[MMKV defaultMMKV] setInt32:(int32_t)num forKey:k_mmkv_collect_min_num];
}

- (void)getLookVideoNumAtMMKV {
    NSString *date = [NSDate getCurrentDayYearMonthDay];
    NSString *key = SF(@"AD-NUM-%@",date);
    self.lookVideoNum = [[MMKV defaultMMKV] getInt32ForKey:key defaultValue:0];
    NSString *yesterKey = SF(@"AD-NUM-%@",[NSDate getYesterdayDateString]);
    BOOL contains = [[MMKV defaultMMKV] containsKey:yesterKey];
    if (contains) {
        [[MMKV defaultMMKV] removeValueForKey:yesterKey];
    }
}

- (void)setLookVideoNumToMMKV {
    NSString *date = [NSDate getCurrentDayYearMonthDay];
    NSString *key = SF(@"AD-NUM-%@",date);
    [[MMKV defaultMMKV] setInt32:(int32_t)self.lookVideoNum forKey:key];
}

- (void)requestGameIndex:(NSInteger)skip
               onSuccess:(OnSuccess)onSuccess
                 onError:(QCHTTPRequestResponseErrorBlock)onSrror {
    __weak typeof(self) weakSelf = self;
    [QCService requestIndex:skip
                    success:^(id  _Nonnull data) {
        weakSelf.answerIndexModel = [QCMusicIndexModel modelWithkeyValues:data];
        [QCUserModel updateUserInfoModel:weakSelf.answerIndexModel.user_info];
        [weakSelf configConditionModel];
        onSuccess();
    } error:onSrror];
}

- (void)configConditionModel {
    [QCAdManager sharedInstance].conditionModel = self.answerIndexModel.xjtx_condition;
    [QCAdManager sharedInstance].conditionModel.xjtx_page = self.answerIndexModel.xjtx_page;
}

- (BOOL)isCheckChooseQuestionRightAtIndex:(NSInteger)index {
    QCMusicOptionModel *optionModel = self.answerIndexModel.question.option[index];
    return optionModel.key == self.answerIndexModel.question.right_key;
}

- (NSInteger)getRightAnswerIndex {
    NSInteger rightKey = self.answerIndexModel.question.right_key;
    NSArray<QCMusicOptionModel *> *options = self.answerIndexModel.question.option;
    for (int i = 0; i < options.count; i ++) {
        QCMusicOptionModel *model = options[i];
        if (rightKey == model.key) {
            return i;
        }
    }
    return 0;
}


- (NSAttributedString *)progressViewGameStageAttributedString {
    QCGameIndexGameProgressModel *progressModel = self.answerIndexModel.game_progress;
    NSString *str = SF(@"第%ld关",progressModel.now_stage_num);
    NSString *text = SF(@"%ld",progressModel.now_stage_num);
    return [str setHighlightText:text colorHex:@"#FFD52B"];
}

- (NSAttributedString *)progressViewMoneyAttributedString {
    NSString *money = SF(@"%@元",self.answerIndexModel.xj_money);
    return [money setStrokeColorHex:@"#1B9823"];
}

- (NSAttributedString *)progressLabelAttributedStringAtMax:(BOOL)max {
    return max ? self.maxprogressLabelAttributedString : self.progressLabelAttributedString;
}

- (NSAttributedString *)progressLabelAttributedString {
    QCGameIndexGameProgressModel *progressModel = self.answerIndexModel.game_progress;
    NSString *progressStr = SF(@"%ld/%ld",progressModel.now_rounds - 1,progressModel.all_rounds);
    return [progressStr setStrokeColorHex:@"#FF6A00"];
}

- (NSAttributedString *)maxprogressLabelAttributedString {
    QCGameIndexGameProgressModel *progressModel = self.answerIndexModel.game_progress;
    NSInteger allGameNum = progressModel.all_rounds;
    NSString *progressStr = SF(@"%ld/%ld",allGameNum,allGameNum);
    return [progressStr setStrokeColorHex:@"#FF6A00"];
}

- (NSString *)subGameNumText {
    NSString *gameNum = @"";
    QCGameIndexGameProgressModel *progressModel = self.answerIndexModel.game_progress;
    if (progressModel.config_game_num > 0) {
        gameNum = SF(@"第%ld/%ld轮",progressModel.now_game_num,progressModel.config_game_num);
    }
    
    if (progressModel.config_act_num > 0) {
        gameNum = SF(@"%@ 第%ld/%ld场",gameNum,progressModel.now_act_num,progressModel.config_act_num);
    }
    
    return gameNum;
}


- (BOOL)canShowHBGroupButton {
    return self.answerIndexModel.user_info.guide_page_num == 4;
}

- (BOOL)checkShowNewUserStreamerGuide {
    if (self.answerIndexModel.user_info.guide_page_num < 4) {
        return self.answerIndexModel.assistant_pop.pop;
    }
    return NO;
}

- (NSString *)cashOutPopText {
    NSString *text = @"可全部提现";
    QCGameCashConditionModel *conditionModel = [QCAdManager sharedInstance].conditionModel;
    NSInteger type = conditionModel.condition_type;
    NSString *value = conditionModel.condition_value;
    if (type == 1) {
        text = SF(@"再过%@关可全部提现",value);
    }else if (type == 2) {
        text = SF(@"再赚%@元可全部提现",value);
    }
    return text;
}

- (BOOL)canShowCashOutPopView {
    NSString *money = self.answerIndexModel.user_info.hbq_money;
    return ![money isEqualToString:@"0"];
}

- (BOOL)checkCollectShowNewUserController {
    NSInteger guidePageNum = self.answerIndexModel.user_info.guide_page_num;
    if (guidePageNum == 1 || guidePageNum == 3) {
        if (self.showGuideRequestLog) {
            self.showGuideRequestLog = NO;
            return YES;
        }
    }
    return NO;
}

- (NSInteger)getCurrenStageNum {
    QCGameIndexGameProgressModel *progressModel = self.answerIndexModel.game_progress;
    return progressModel.now_stage_num;
}

- (BOOL)checkNewUser {
    return self.getCurrenStageNum < 3;
}


- (BOOL)checkShowNewUserRelationsGuideToast {
    QCGameIndexGameProgressModel *progressModel = self.answerIndexModel.game_progress;
    return self.getCurrenStageNum == 2 && progressModel.now_rounds == 1 && !self.isShowSecondToast;
}

- (void)showNewUserRelationsGuideToast {
    self.isShowSecondToast = YES;
}

//判断是否是通关
- (BOOL)checkRelations {
    QCGameIndexGameProgressModel *progressModel = self.answerIndexModel.game_progress;
    NSInteger gameNum = progressModel.now_rounds;
    NSInteger allGameNum = progressModel.all_rounds;
    return gameNum == allGameNum;
}

- (float)progressValueAtMax:(BOOL)max {
    QCGameIndexGameProgressModel *progressModel = self.answerIndexModel.game_progress;
    NSInteger nowGameNum = progressModel.now_rounds - 1;
    NSInteger allGameNum = progressModel.all_rounds;
    float value = 0.0;
    if (max) {
        value = 1.0;
    }else {
        value = (float) nowGameNum / allGameNum ;
    }
    return value;
}

- (BOOL)showHbCashPopView {
    return self.answerIndexModel.hb_can_tx;
}

- (void)requestCollectNewUserGold:(OnSuccess)success onError:(QCHTTPRequestResponseErrorBlock)onError {
    __weak typeof(self) weakSelf = self;
    QCGameIndexGameProgressModel *progressModel = self.answerIndexModel.game_progress;
    BOOL first = progressModel.now_stage_num == 1 ? YES : NO;
    [QCService requestCollectNewUserTgGoldAtFisrt:first success:^(id  _Nonnull data) {
        [weakSelf parsedCollectGold:data onSuccess:success];
    } error:onError];
}

- (void)addLookVideoNum {
    self.lookVideoNum ++;
    [self setLookVideoNumToMMKV];
}

- (void)requestMaxCollect:(QCAdEcpmInfoModel *)infoModel
                    success:(OnSuccess)success
                      error:(QCHTTPRequestResponseErrorBlock)error {
    __weak typeof(self) weakSelf = self;
    [QCService requestCollectVideoGold:self.checkRelations
                              ecpmInfo:infoModel
                               success:^(id  _Nonnull data) {
        [weakSelf parsedCollectGold:data onSuccess:success];
        [weakSelf uploadAdTimeWithLogId:weakSelf.collectGoldModel.gold_log_id ecpmInfo:infoModel];
        [weakSelf addLookVideoNum];
    } error:error];
}

- (void)requestMinCollectSuccess:(OnSuccess)success error:(QCHTTPRequestResponseErrorBlock)error {
    __weak typeof(self) weakSelf = self;
    [QCService requestCollectMinGold:self.checkRelations success:^(id  _Nonnull data) {
        if (!weakSelf.checkRelations) {
            weakSelf.collectMinGoldNum ++;
            [weakSelf setUpCollectionMum:weakSelf.collectMinGoldNum];
        }
        [weakSelf parsedCollectGold:data onSuccess:success];
    } error:error];
}

- (void)requestAutoCollectGold:(QCAdEcpmInfoModel *)infoModel
                       Success:(OnSuccess)success
                         error:(QCHTTPRequestResponseErrorBlock)error {
    __weak typeof(self) weakSelf = self;
    [QCService requestCollectCgAutoFbGold:infoModel success:^(id  _Nonnull data) {
        weakSelf.collectMinGoldNum = 0;
        [weakSelf setUpCollectionMum:weakSelf.collectMinGoldNum];
        [weakSelf parsedCollectGold:data onSuccess:success];
        [weakSelf uploadAdTimeWithLogId:weakSelf.collectGoldModel.gold_log_id ecpmInfo:infoModel];
        [weakSelf addLookVideoNum];
    } error:error];
}

- (BOOL)canAutoCollect {
    QCUserModel *userModel = [QCUserModel getUserModel];
    return userModel.auto_fb_jg;
}

- (BOOL)checkCollectAutoGold {
    if(!self.checkRelations) {
        if (self.canAutoCollect) {
            QCUserModel *userModel = [QCUserModel getUserModel];
            return self.collectMinGoldNum >= userModel.auto_fb_jg;
        }
    }
    return NO;
}

- (void)parsedCollectGold:(id)data onSuccess:(OnSuccess)onSuccess {
    self.collectGoldModel = [QCCollectGoldModel modelWithkeyValues:data];
    [self updateUserInfo];
    onSuccess();
}

- (void)updateUserInfo {
    QCUserInfoModel *userInfoModel = [QCUserModel getUserModel].user_info;
    userInfoModel.gold_money = self.collectGoldModel.gold_money;
    userInfoModel.hbq_money = self.collectGoldModel.hbq_money;
    [QCUserModel updateUserInfoModel:userInfoModel];
}

- (void)setShowNewUserKey {
    [[MMKV defaultMMKV] setBool:YES forKey:k_mmkv_show_xs];
}

- (BOOL)getShowNewUserKey {
    return [[MMKV defaultMMKV] getBoolForKey:k_mmkv_show_xs defaultValue:NO];
}

- (BOOL)canShowNewUserGuide {
    BOOL canShow = [self getShowNewUserKey];
    BOOL isNetWorkShow = self.answerIndexModel.user_info.guide_page_num == 0;
    return isNetWorkShow && !canShow;
}


- (BOOL)canShowCashWithdrawalView {
    QCUserModel *model = [QCUserModel getUserModel];
    if (model.area_is_show) {
        if (self.answerIndexModel.user_info.guide_page_num == 4) {
            QCAdDownloadConfig *config = [self getAdDownloadConfig];
            if (config) {
                if (config.xjhb_status) {
                    return config.sy_num;
                }
            }
        }
    }
    return NO;
}

- (QCAdDownloadConfig *)getAdDownloadConfig {
    return [QCAdManager sharedInstance].commedHomeIndexModel.ad_download_config;
}

- (BOOL)canPushCashHb {
    return self.canCashHb;
}

- (BOOL)canShowWechatCashToast {
    QCUserModel *model = [QCUserModel getUserModel];
    if (model.area_is_show) {
        QCAdDownloadConfig *downloadConfig = [self getAdDownloadConfig];
        if (downloadConfig.xjhb_status) {
            if (downloadConfig.sy_num) {
                NSArray<NSString *> *nums = [downloadConfig.pop_config componentsSeparatedByString:@"&"];
                NSString *lookVideoNumStr = SF(@"%ld",self.lookVideoNum);
                for (NSString *num in nums) {
                    if ([lookVideoNumStr isEqualToString:num]) {
                        return YES;
                    }
                }
            }
        }
    }
    return NO;
}


- (void)startTimerHandler:(void(^)(NSString *))handler {
    [self endTimer];
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(self.timer, dispatch_time(DISPATCH_TIME_NOW, 0), 1 * NSEC_PER_SEC, 0);
    __weak typeof(self) weakSelf = self;
    dispatch_source_set_event_handler(self.timer, ^{
        weakSelf.cashMaxTime --;
        if (weakSelf.cashMaxTime <= 0) {
            [weakSelf endTimer];
            handler(@"现金提现");
            weakSelf.canCashHb = YES;
        }else {
            NSString *time = [NSDate convertSeconds:weakSelf.cashMaxTime];
            handler(time);
            weakSelf.canCashHb = NO;
        }
    });
    dispatch_resume(self.timer);
}

- (void)endTimer {
    if (self.timer) {
        dispatch_source_cancel(self.timer);
        self.timer = nil;
        self.cashMaxTime = 300;
    }
}

@end
