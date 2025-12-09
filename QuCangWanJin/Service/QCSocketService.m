
#import "QCSocketService.h"
#import "GCDAsyncUdpSocket.h"

@interface QCSocketService ()<GCDAsyncUdpSocketDelegate>

@property (nonatomic, strong) GCDAsyncUdpSocket *sendSocket;
@property (nonatomic, strong) QCAdReportModel *reportModel;

@end

@implementation QCSocketService

+ (instancetype)sharedInstance {
    static QCSocketService *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[super allocWithZone:NULL] init];
    });
    return instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [self sharedInstance];
}

// 重写方法【必不可少】
- (id)copyWithZone:(nullable NSZone *)zone{
    return self;
}

- (GCDAsyncUdpSocket *)sendSocket {
    if (!_sendSocket) {
        dispatch_queue_t qQueue = dispatch_queue_create("Client queue", NULL);
        _sendSocket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self
                                                    delegateQueue:qQueue];
    }
    return _sendSocket;
}

- (void)bindPort:(QCAdReportModel *)reportModel {
    if (self.reportModel) {return;}
    self.reportModel = reportModel;
    NSError *error;
    [self.sendSocket bindToPort:[reportModel.udp_port intValue] error:&error];
    [self.sendSocket beginReceiving:nil];
}


- (void)sendMessage:(NSString *)message type:(NSInteger)type {
    NSLog(@"sendMessage ---- %@",message);
    if (![self canSendWithType:type]) { return; }
    NSData *sendData = [message dataUsingEncoding:NSUTF8StringEncoding];
    uint16_t port = [self.reportModel.udp_port intValue];
    [self.sendSocket sendData:sendData toHost:self.reportModel.udp_ip port:port withTimeout:60 tag:200];
}

- (BOOL)canSendWithType:(NSInteger)type {
    switch (type) {
        case 1:
            return self.reportModel.ad_log_type.show;
        case 2:
            return self.reportModel.ad_log_type.click;
        default:
            break;
    }
    return NO;
}

#pragma mark - delegate
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError *)error {
    if (tag == 200) {
        NSLog(@"client发送失败-->%@",error);
    }
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data fromAddress:(NSData *)address withFilterContext:(id)filterContext {
    NSString *receiveStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"服务器ip地址--->%@,host---%u,内容--->%@",
          [GCDAsyncUdpSocket hostFromAddress:address],
          [GCDAsyncUdpSocket portFromAddress:address],
          receiveStr);
    
}


@end
