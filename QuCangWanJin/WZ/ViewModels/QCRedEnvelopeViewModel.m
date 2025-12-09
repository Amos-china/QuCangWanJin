#import "QCRedEnvelopeViewModel.h"
#import "AQService+Chat.h"
#import "QCGroupMessageDao.h"
#import "QCDatabaseManager.h"
#import "AQService+Task.h"

@interface QCRedEnvelopeViewModel ()

@property (nonatomic, strong) NSMutableArray<QCGroupMessageModel *> *preparationList;

@end

@implementation QCRedEnvelopeViewModel

- (instancetype)init {
    if (self = [super init]) {
        self.isCanSend = YES;
        [[QCDatabaseManager sharedManager] createTables];
    }
    return self;
}

- (NSMutableArray<QCGroupMessageModel *> *)preparationList {
    if (!_preparationList) {
        _preparationList = [NSMutableArray array];
    }
    return _preparationList;
}

- (NSMutableArray<QCGroupMessageModel *> *)msgList {
    if (!_msgList) {
        _msgList = [NSMutableArray array];
    }
    return _msgList;
}

- (void)createData:(OnSuccess)success error:(QCHTTPRequestResponseErrorBlock)error {
    NSArray<QCGroupMessageModel *> *list = [[QCGroupMessageDao sharedDao] getMessagesByGroupId:1];
    if (list.count) {
        [self.msgList addObjectsFromArray:list];
        success();
    }else {
        __weak typeof(self) weakSelf = self;
        [self requestChatMessage:^(NSArray<QCGroupMessageModel *> *models) {
            [weakSelf.msgList addObjectsFromArray:models];
            [[QCGroupMessageDao sharedDao] insertMessages:models];
            success();
        } error:error];
    }
}

- (void)requestChatMessage:(void(^)(NSArray<QCGroupMessageModel *> *models))block
                     error:(QCHTTPRequestResponseErrorBlock)error {
    __weak typeof(self) weakSelf = self;
    [QCService getChatMsgSuccess:^(id  _Nonnull data) {
        NSArray<QCGroupMessageModel *> *list = [weakSelf parseData:data];
        block(list);
    } error:error];
}

- (void)requestAotuSendData {
    __weak typeof(self) weakSelf = self;
    [self requestChatMessage:^(NSArray<QCGroupMessageModel *> *models) {
        [weakSelf.preparationList addObjectsFromArray:models];
    } error:^(NSInteger code, NSString * _Nonnull msg) {
        //如果请求失败了就等待3秒，再次发送一次请求
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [weakSelf requestAotuSendData];
        });
    }];
}

- (NSArray<QCGroupMessageModel *> *)parseData:(id)data {
    NSMutableArray<QCGroupMessageModel *> *list = [QCGroupMessageModel mj_objectArrayWithKeyValuesArray:data];
    int index = arc4random_uniform(3) + 1;
    NSString *time = [NSDate formatCurrentTime];
    long long timeValue = [time longLongValue];
    for (int i = 0; i < list.count; i ++) {
        QCGroupMessageModel *messageModel = list[i];
        timeValue += 1;
        messageModel.time = SF(@"%lld",timeValue);
        messageModel.messageId = messageModel.time;
        messageModel.groupId = 1;
        if (index == i) {
            messageModel.type = 2;
            messageModel.collectStatus = 0;
            index = arc4random_uniform(4) + index + 2;
        }
    }
    
    //信息流广告
    if (self.msgList.count) {
        NSInteger adIndex = 4;
        for (int i = 0; i < 3; i ++) {
            QCGroupMessageModel *adMsgModel = [[QCGroupMessageModel alloc] init];
            adMsgModel.type = 3;
            [list insertObject:adMsgModel atIndex:adIndex * i + 1];
        }
    }
    
    return list;
}

- (BOOL)aotuSendMsgWithController:(UIViewController *)controller {
    
    if (!self.isCanSend) {
        return NO;
    }
    
    if (self.preparationList.count == 0) {
        return NO;
    }
    
    if (self.preparationList.count < 5) {
        //这个时候要去请求数据了
        [self requestAotuSendData];
    }
    
    QCGroupMessageModel *msgModel = self.preparationList.firstObject;
    msgModel.time = [NSDate formatCurrentTime];
    msgModel.messageId = msgModel.time;
    if (msgModel.type == 3) {
        msgModel.adView = [[QCAdManager sharedInstance] getNativeADViewWithController:controller];
        if (msgModel.adView) {
            [self.msgList addObject:msgModel];
            [self.preparationList removeObjectAtIndex:0];
            return YES;
        }
        [self.preparationList removeObjectAtIndex:0];
        return NO;
    }
    
    BOOL send = [[QCGroupMessageDao sharedDao] insertMessage:msgModel];
    if (send) {
        [self.msgList addObject:msgModel];
        [self.preparationList removeObjectAtIndex:0];
    }
    return send;
}

- (BOOL)sendMsg:(NSString *)content {
    QCGroupMessageModel *msgModel = [[QCGroupMessageModel alloc] init];
    msgModel.type = 1;
    msgModel.content = content;
    msgModel.groupId = 1;
    msgModel.time = [NSDate formatCurrentTime];
    msgModel.messageId = msgModel.time;
    
    QCUserModel *userInfoModel = [QCUserModel getUserModel];
    msgModel.face = userInfoModel.user_info.face;
    msgModel.nickname = userInfoModel.user_info.nickname;
    
    BOOL send = [[QCGroupMessageDao sharedDao] insertMessage:msgModel];
    if (send) {
        [self.msgList addObject:msgModel];
    }
    return send;
}

- (void)requestCollectTask:(NSInteger)task
                  ecpmInfo:(QCAdEcpmInfoModel *)ecpmInfo
                   success:(OnSuccess)success
                     error:(QCHTTPRequestResponseErrorBlock)error {
    __weak typeof(self) weakSelf = self;
    [QCService requstCollectHbGoldAtTask:task ecpmInfoModel:ecpmInfo success:^(id  _Nonnull data) {
        weakSelf.collectGoldModel = [QCCollectGoldModel modelWithkeyValues:data];
        QCUserInfoModel *userInfo = [QCUserModel getUserModel].user_info;
        userInfo.gold_money = weakSelf.collectGoldModel.gold_money;
        userInfo.hbq_money = weakSelf.collectGoldModel.hbq_money;
        [QCUserModel updateUserInfoModel:userInfo];
        QCGroupMessageModel *model = weakSelf.getSelectMessageModel;
        model.collectStatus = 1;
        [[QCGroupMessageDao sharedDao] updateMessage:model];
        [weakSelf uploadAdTimeWithLogId:weakSelf.collectGoldModel.gold_log_id ecpmInfo:ecpmInfo];
        success();
    } error:error];
}

- (QCGroupMessageModel *)getSelectMessageModel {
    return self.msgList[self.selectIndexPath.row];
}


@end
