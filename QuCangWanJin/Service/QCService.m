//
//  DouYinService.m
//  Zhiyuan
//
//  Created by 陈志远 on 2020/12/11.
//  Copyright © 2020 陈志远. All rights reserved.
//

#import "QCService.h"
#import "QCServiceUtils.h"
#import "UuidObject.h"

NSInteger const kAFNetworkingTimeoutInterval = 30;
NSString const *kBaseHost = @"https://qcwjios.txapk.com/api/v";
NSString const *kWX_BASE_HOST = @"https://api.weixin.qq.com/sns/";


@implementation QCService

+ (NSString *)getApiVersion {
    return @"2571";
}

static AFHTTPSessionManager *aManager;

+ (AFHTTPSessionManager *)sharedAFManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        // 配置URLSession以支持自定义SSL处理
        configuration.TLSMinimumSupportedProtocolVersion = tls_protocol_version_TLSv12;
        // 其他优化配置
        aManager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:configuration];
        //以下三项manager的属性根据需要进行配置
        aManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/xml",@"text/json",@"text/plain",@"text/JavaScript",@"application/json",@"image/jpeg",@"image/png",@"application/octet-stream",nil];
        
        aManager.responseSerializer = [AFHTTPResponseSerializer serializer];
        aManager.requestSerializer = [AFJSONRequestSerializer serializer];
        // 设置超时时间
        aManager.requestSerializer.timeoutInterval = kAFNetworkingTimeoutInterval;
        
        AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        [securityPolicy setAllowInvalidCertificates:YES];
        [securityPolicy setValidatesDomainName:NO];
        aManager.securityPolicy = securityPolicy;
        
        // 设置Session级别的认证处理
        [aManager setSessionDidReceiveAuthenticationChallengeBlock:^NSURLSessionAuthChallengeDisposition(NSURLSession * _Nonnull session, NSURLAuthenticationChallenge * _Nonnull challenge, NSURLCredential *__autoreleasing  _Nullable * _Nullable credential) {
            
            NSLog(@"[AQService] 收到认证挑战: %@", challenge.protectionSpace.authenticationMethod);
            
            // 处理服务器信任认证（SSL证书验证）
            if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
                // 创建凭证，信任服务器证书
                *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
                NSLog(@"[AQService] 信任服务器证书: %@", challenge.protectionSpace.host);
                return NSURLSessionAuthChallengeUseCredential;
            }
            
            // 其他认证方式使用默认处理
            return NSURLSessionAuthChallengePerformDefaultHandling;
        }];
        
        NSLog(@"[AQService] AFHTTPSessionManager 初始化完成");
        NSLog(@"[AQService] SSL配置 - AllowInvalidCertificates: YES, ValidatesDomainName: NO");
        
        
    });
    return aManager;  
}

+ (void)requestWithType:(MTHttpRequestType)type
              urlString:(NSString *)urlString
             parameters:(NSDictionary *)parameters
           successBlock:(QCHTTPRequestSuccessBlock)successBlock
           failureBlock:(QCHTTPRequestFailedBlock)failureBlock {
    if (urlString == nil) {
        return;
    }
    
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    if (type == MXEHttpRequestTypeGet) {
        [[self sharedAFManager] GET:urlString parameters:parameters headers:nil progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if (successBlock){
                id JSON =  [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                if ([JSON isKindOfClass:[NSDictionary class]]) {
                    successBlock(JSON);
                }
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (error.code != -999) {
                if (failureBlock) {
                    failureBlock(error);
                }
            }else{
                NSLog(@"取消队列了");
            }
        }];
    }
    if (type == MXEHttpRequestTypePost){
        
        [[self sharedAFManager] POST:urlString parameters:parameters headers:nil progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            id JSON =  [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            if (successBlock){
                successBlock(JSON);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (error.code !=-999) {
                if (failureBlock){
                    failureBlock(error);
                }
            }else{
                NSLog(@"取消队列了");
            }
        }];
    }
}

+ (void)cancelDataTask {
    NSMutableArray *dataTasks = [NSMutableArray arrayWithArray:[self sharedAFManager].dataTasks];
    for (NSURLSessionDataTask *taskObj in dataTasks) {
        [taskObj cancel];
    }
}

+ (void)postRequestWithApi:(NSString *)api
                     param:(NSDictionary *)param
                   success:(void (^)(NSDictionary * _Nonnull))success
                   failure:(void (^)(id _Nonnull))failure {
    NSString *requestUrl = SF(@"%@%@",kBaseHost,api);
    [self requestWithType:MXEHttpRequestTypePost urlString:requestUrl parameters:param successBlock:^(id responseObject) {
        success(responseObject);
    } failureBlock:^(NSError *error) {
        failure(error);
    }];
}

+ (void)getRequestWithApi:(NSString *)api
                    param:(NSDictionary *)param
                  success:(void(^)(NSDictionary *rootDict))success
                  failure:(void(^)(id error))failure {
    NSString *requestUrl = SF(@"%@%@",kBaseHost,api);
    [self requestWithType:MXEHttpRequestTypeGet urlString:requestUrl parameters:param successBlock:^(id responseObject) {
        success(responseObject);
    } failureBlock:^(NSError *error) {
        failure(error);
    }];
}

+ (void)wechatGetRequestApi:(NSString *)api              
                      param:(NSDictionary *)param
                    success:(void (^)(NSDictionary * _Nonnull))success
                    failure:(void (^)(id _Nonnull))failure {
    NSString *requestUrl = SF(@"%@%@",kWX_BASE_HOST,api);
    [self requestWithType:MXEHttpRequestTypeGet urlString:requestUrl parameters:param successBlock:^(id responseObject) {
        success(responseObject);
    } failureBlock:^(NSError *error) {
        failure(error);
    }];
}

+ (void)wechatPostRequestApi:(NSString *)api
                      param:(NSDictionary *)param
                    success:(void (^)(NSDictionary * _Nonnull))success
                    failure:(void (^)(id _Nonnull))failure {
    NSString *requestUrl = SF(@"%@%@",kWX_BASE_HOST,api);
    [self requestWithType:MXEHttpRequestTypePost urlString:requestUrl parameters:param successBlock:^(id responseObject) {
        success(responseObject);
    } failureBlock:^(NSError *error) {
        failure(error);
    }];
}

/// 核心接口（加密 + RSA + 自定义 header）——修复SSL错误
+ (void)appApiRequestWithApi:(NSString *)api
                       param:(NSDictionary *)param
                     success:(QCHTTPRequestResponseSuccessBlock)success
                     failure:(QCHTTPRequestResponseErrorBlock)failure {

    // 1. 拼接完整 URL
    NSString *apiVersion = [self getApiVersion];
    NSString *requestURL = [NSString stringWithFormat:@"%@%@.%@", kBaseHost, apiVersion, api];

    NSLog(@"[AQService] 请求地址: %@", requestURL);
    NSLog(@"[AQService] 基础域名: %@", kBaseHost);

    // 2. 合并 + RSA 加密参数
    NSDictionary *mergedParam = [QCServiceUtils mergeRequestParameters:param];
    NSData *encryptedBodyData = [QCServiceUtils requestParamToRSAData:mergedParam];

    // 3. 获取已配置好SSL策略的manager
    AFHTTPSessionManager *manager = [self sharedAFManager];
    
    // 验证SSL策略配置
    NSLog(@"[AQService] SSL策略 - AllowInvalidCertificates: %d, ValidatesDomainName: %d",
          manager.securityPolicy.allowInvalidCertificates,
          manager.securityPolicy.validatesDomainName);
    
    // 4. 使用manager的requestSerializer（确保继承所有配置）
    AFJSONRequestSerializer *requestSerializer = (AFJSONRequestSerializer *)manager.requestSerializer;
    
    // 设置自定义headers
    [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [requestSerializer setValue:[QCAdManager sharedInstance].deviceIDFA forHTTPHeaderField:@"oaid"];
    [requestSerializer setValue:[UuidObject getIDFV] forHTTPHeaderField:@"idfv"];
    
    // token（如果存在）
    QCUserModel *userModel = [QCUserModel getUserModel];
    if (userModel && userModel.user_info.token) {
        [requestSerializer setValue:userModel.user_info.token forHTTPHeaderField:@"token"];
    }

    // 5. 创建请求
    NSError *serializeError = nil;
    NSMutableURLRequest *request = [requestSerializer requestWithMethod:@"POST"
                                                              URLString:requestURL
                                                             parameters:nil
                                                                  error:&serializeError];
    if (serializeError) {
        NSLog(@"[AQService] 请求序列化失败: %@", serializeError);
        failure(-999, @"请求序列化失败");
        return;
    }

    // 6. 设置加密后的body
    [request setHTTPBody:encryptedBodyData];

    NSLog(@"[AQService] 请求Headers: %@", request.allHTTPHeaderFields);

    // 7. 使用manager发送请求（确保使用已配置的SSL策略）
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request
                                                    uploadProgress:nil
                                                  downloadProgress:nil
                                                 completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        if (error) {
            if (error.code != NSURLErrorCancelled) {  // -999
                NSLog(@"[AQService] ❌ 请求失败");
                NSLog(@"[AQService] 错误代码: %ld", (long)error.code);
                NSLog(@"[AQService] 错误描述: %@", error.localizedDescription);
                NSLog(@"[AQService] 错误详情: %@", error);
                NSLog(@"[AQService] 失败URL: %@", error.userInfo[NSURLErrorFailingURLStringErrorKey]);
                NSString *msg = error.localizedDescription;
                if (error.code == -1001) {
                    //request timed out.
                    msg = @"请求超时";
                }else if (error.code == -1200) {
                    //ssl错误
                    msg = @"当前网络不稳定,请稍后重试";
                }else {
                    msg = error.localizedDescription;
                }
                [self addUmengLog:error.code userInfo:error.userInfo];
                failure(SERVICE_REQUEST_ERROR_CODE, msg);
            } else {
                NSLog(@"[AQService] 请求被主动取消");
            }
            return;
        }

        // 8. 解析响应
        NSError *jsonError = nil;
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject
                                                            options:kNilOptions
                                                              error:&jsonError];
        if (jsonError) {
            NSLog(@"[AQService] JSON解析失败: %@", jsonError);
            failure(SERVICE_REQUEST_ERROR_CODE, @"JSON解析失败");
            return;
        }

        NSLog(@"[AQService] ✅ 请求成功: %@", dict);

        QCRootModel *rootModel = [QCRootModel modelWithkeyValues:dict];
        
        if (rootModel.code == 1) {
            // 成功
            if (success) {
                success(rootModel.data);
            }
        } else if (rootModel.code == -1) {
            // token 失效
            [QCUserModel deleteUserModel];
            [self showLoginLoseAlertMsg:rootModel.msg ?: @"登录已失效，请重新登录"];
        } else {
            // 业务错误
            if (failure) {
                failure(rootModel.code, rootModel.msg ?: @"未知错误");
            }
        }
    }];
    
    [dataTask resume];
}

+ (void)showResetRequestAlertWithMsg:(NSString *)msg actionHandler:(void(^)(void))actionHandler {
    UIViewController *rootController = APPDELEGATE.window.rootViewController;
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示信息" message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"重试" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        actionHandler();
    }];
    [alertController addAction:action];
    [rootController presentViewController:alertController animated:YES completion:nil];
}

+ (void)showLoginLoseAlertMsg:(NSString *)msg {
    UIViewController *rootController = APPDELEGATE.window.rootViewController;
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示信息" message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"退出应用" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        exit(0);
    }];
    [alertController addAction:action];
    [rootController presentViewController:alertController animated:YES completion:nil];
}

+ (void)addUmengLog:(NSInteger)code userInfo:(NSDictionary *)userInfo {
    NSString *eventId = @"request_error";
    if (code == -1200) {
        eventId = @"ssl_error";
    }else if (code == -1001) {
        eventId = @"request_timed_out";
    }else {
        eventId = @"request_error";
    }
    NSMutableDictionary *attributes = userInfo.mutableCopy;
    QCUserModel *userModel = [QCUserModel getUserModel];
    if (userInfo && userModel.user_info.user_id.length != 0) {
        attributes[@"app_user_id"] = userModel.user_info.user_id;
    }
    
    [MobClick event:eventId attributes:attributes];
}

@end
