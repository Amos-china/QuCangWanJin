//
//  DouYinService.h
//  Zhiyuan
//
//  Created by 陈志远 on 2020/12/11.
//  Copyright © 2020 陈志远. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QCRootModel.h"
#import <AFNetworking/AFNetworking.h>

NS_ASSUME_NONNULL_BEGIN

static NSInteger const SERVICE_REQUEST_ERROR_CODE = -2000;

/** 请求类型的枚举 */
typedef NS_ENUM(NSUInteger, MTHttpRequestType){
    /** get请求 */
    MXEHttpRequestTypeGet = 0,
    /** post请求 */
    MXEHttpRequestTypePost
};

/**
 http通讯成功的block

 @param responseObject 返回的数据
 */
typedef void (^QCHTTPRequestSuccessBlock)(NSDictionary *responseObject);

/**
 http通讯失败后的block

 @param error 返回的错误信息
 */
typedef void (^QCHTTPRequestFailedBlock)(NSError *error);

typedef void(^QCHTTPRequestResponseSuccessBlock)(id data);
typedef void(^QCHTTPRequestResponseErrorBlock)(NSInteger code, NSString *msg);

@interface QCService : NSObject

/**
 *  网络请求的实例方法
 *
 *  @param type         get / post (项目目前只支持这倆中)
 *  @param urlString    请求的地址
 *  @param parameters   请求的参数
 *  @param successBlock 请求成功回调
 *  @param failureBlock 请求失败回调
 */
+ (void)requestWithType:(MTHttpRequestType)type
              urlString:(NSString *)urlString
             parameters:(NSDictionary *)parameters
           successBlock:(QCHTTPRequestSuccessBlock)successBlock
           failureBlock:(QCHTTPRequestFailedBlock)failureBlock;

/**
 取消队列
 */
+(void)cancelDataTask;


+ (void)postRequestWithApi:(NSString *)api
                     param:(NSDictionary *)param
                   success:(void(^)(NSDictionary *rootDict))success
                   failure:(void(^)(id error))failure;

+ (void)getRequestWithApi:(NSString *)api
                    param:(NSDictionary *)param
                  success:(void(^)(NSDictionary *rootDict))success
                  failure:(void(^)(id error))failure;

+ (void)wechatGetRequestApi:(NSString *)api
                      param:(NSDictionary *)param
                    success:(void (^)(NSDictionary * _Nonnull))success
                    failure:(void (^)(id _Nonnull))failure;

+ (void)wechatPostRequestApi:(NSString *)api
                      param:(NSDictionary *)param
                    success:(void (^)(NSDictionary * _Nonnull))success
                     failure:(void (^)(id _Nonnull))failure;

+ (void)appApiRequestWithApi:(NSString *)api
                       param:(NSDictionary *)param
                     success:(QCHTTPRequestResponseSuccessBlock)success
                     failure:(QCHTTPRequestResponseErrorBlock)failure;

+ (NSString *)getApiVersion;

@end

NS_ASSUME_NONNULL_END
