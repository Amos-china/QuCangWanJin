//
//  MTServiceUtils.m
//  MelonTheater
//
//  Created by 陈志远 on 2023/12/26.
//

#import "QCServiceUtils.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonHMAC.h>
#import "RSA.h"
#import "QCService.h"
#import "AppDeviceInfo.h"

static NSString *pubkey = @"-----BEGIN PUBLIC KEY-----\
MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAoCSLcMP+qv7qA21jJbwK\
hZ80/M01yne77LGcGMu+9iK3uZT6630n9E8W20m/oHqQnf/e1LNtBWt1QkUeaGW8\
d1x1sB51FrSPdqlPkj0LEkeryA+aFdiE5SE1CYjYRCgNB0NZKNdiaYx+/Egu1XE/\
87nsIs1R7STovd8Qrd7yXjBGH/cUJseEQFt09X1OkdRjuKs+YUBfAeCty3Rb4JTe\
/crDNhx/RlhPPKaNbOi3XTMRiBhEhLH446rVgDiyLFiHnFyZZmaIQjNaB3t31N0o\
VAv1gMNaKfU0SRWaQFNww69Mhb6z+/C4Ina9VYSgFBYTaa2BRDQktvmQToUm/mtb\
uwIDAQAB\
-----END PUBLIC KEY-----";


@implementation QCServiceUtils

/***
 signature签名算法：

      1、将参数按照键名字母升序排序。
      2、遍历排序后的键值对，将键和其URL编码后的值用英文分号连接起来，形成一个字符串 $sign_str（如：'a=1;b=2;c=3;'）。
      3、将时间戳追加到 $sign_str 的末尾。（如：$sign_str .= "timestamp=" . $timestamp）
      4、取出公钥内容（sigen_key）拼接在$sign_str前面。（如：$sign_to_str = $sigen_key . ";" . $sign_str）。
      5、使用 SHA-256 算法对 $sign_to_str 进行哈希。
      6、对得到的哈希再次使用 MD5 算法进行哈希，最终的 MD5 哈希值作为签名返回。
 */

+ (NSString *)getRequestSignatureWithParam:(NSDictionary *)param timestamp:(NSString *)timestamp {
    NSArray *sortkeys = [self sortDictionarykeyWithParam:param];
    
    NSString *signStr = @"";
    for (NSString *key in sortkeys) {
        NSString *value = param[key];
        NSString *urlValue = [value stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        NSString *keyAndValue = SF(@"%@=%@;",key,urlValue);
        signStr = SF(@"%@%@",signStr,keyAndValue);
    }
    
    signStr = SF(@"%@timestamp=%@",signStr,timestamp);
    
    signStr = SF(@"%@;%@",pubkey,signStr);

    signStr = [self sha256HashFor:signStr];
    
    return [self stringToMD5String:signStr];
}


+ (NSArray *)sortDictionarykeyWithParam:(NSDictionary *)param {
    NSArray *keyArr = [param allKeys];
    NSArray *sortArray = [keyArr sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    return sortArray;
}

+ (NSString*)sha256HashFor:(NSString*)input{
    const char* str = [input UTF8String];
    unsigned char result[CC_SHA256_DIGEST_LENGTH];
    CC_SHA256(str, (CC_LONG)strlen(str), result);
    
    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH*2];
    for(int i = 0; i<CC_SHA256_DIGEST_LENGTH; i++)
    {
        //输出格式：占位为2的十六进制
        [ret appendFormat:@"%02x",result[i]];
    }
    //大写
    ret = (NSMutableString *)[ret uppercaseString];
    return ret;
}

+ (NSString *)stringToMD5String:(NSString *)sourceString {
    if(!sourceString){
        return nil;//判断sourceString如果为空则直接返回nil。
    }
    //MD5加密都是通过C级别的函数来计算，所以需要将加密的字符串转换为C语言的字符串
    const char *cString = sourceString.UTF8String;
    //创建一个C语言的字符数组，用来接收加密结束之后的字符
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    //MD5计算（也就是加密）
    //第一个参数：需要加密的字符串
    //第二个参数：需要加密的字符串的长度
    //第三个参数：加密完成之后的字符串存储的地方
    CC_MD5(cString, (CC_LONG)strlen(cString), result);
    //将加密完成的字符拼接起来使用（16进制的）。
    //声明一个可变字符串类型，用来拼接转换好的字符
    NSMutableString *resultString = [[NSMutableString alloc]init];
    //遍历所有的result数组，取出所有的字符来拼接
    for (int i = 0;i < CC_MD5_DIGEST_LENGTH; i++) {
        [resultString  appendFormat:@"%02x",result[i]];
        //%02x：x 表示以十六进制形式输出，02 表示不足两位，前面补0输出；超出两位，不影响。当x小写的时候，返回的密文中的字母就是小写的，当X大写的时候返回的密文中的字母是大写的。
    }
    //打印最终需要的字符
    return resultString;
}

+ (NSData *)requestParamToRSAData:(NSDictionary *)param {
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:param
                                                       options:(NSJSONWritingOptions) 0
                                                         error:&error];
    NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSLog(@"请求参数--->%@",jsonStr);
    jsonStr = [RSA encryptString:jsonStr publicKey:pubkey];
    return [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
}


+ (NSData *)requestParamToData:(NSDictionary *)param  {
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:param
                                                       options:(NSJSONWritingOptions) 0
                                                         error:&error];
    NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSLog(@"请求参数--->%@",jsonStr);
    return [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
}


+ (NSDictionary *)mergeRequestParameters:(NSDictionary *)param {
    NSMutableDictionary *totalParam = [[self requestDefaultParam] mutableCopy];
    [param enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [totalParam setObject:obj forKey:key];
    }];
    return totalParam;
}

+ (NSDictionary *)requestDefaultParam {
    return @{
        @"app_id" : [QCService getApiVersion],
        @"version_num": [AppDeviceInfo getCurrentAppVersion],
        @"version_code": [AppDeviceInfo getCurrentAppVersionCode],
        @"agent_id": @"1"
    };
}

+ (NSString *)nowTimeInterval {
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval time = [date timeIntervalSince1970];
    NSString *timeStr = [NSString stringWithFormat:@"%.0f", time];
    return timeStr;
}

@end
