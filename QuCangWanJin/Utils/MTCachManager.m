//
//  MTCachManager.m
//  MelonTheater
//
//  Created by 陈志远 on 2023/12/20.
//

#import "MTCachManager.h"
@implementation MTCachManager


+ (NSString *)getCachSize {
    NSString * cachPath = [ NSSearchPathForDirectoriesInDomains ( NSCachesDirectory , NSUserDomainMask , YES ) firstObject ];
    return [NSString stringWithFormat:@"%.2f MB",[self folderSizeAtPath:cachPath]];
}

+ (void)cleanCach {
    NSString * cachPath = [ NSSearchPathForDirectoriesInDomains ( NSCachesDirectory , NSUserDomainMask , YES ) firstObject ];
    NSFileManager *fm = [NSFileManager defaultManager];//创建文件管理器
    BOOL exist = [fm fileExistsAtPath:cachPath];//判断路径下的路径是否存在
    NSError *err;
    if (exist) {
        [fm removeItemAtPath:cachPath error:&err];//移除此文件夹
        NSLog(@"file deleted");
        if (err) {
            NSLog(@"file remove error, %@", err.localizedDescription );
        }
    } else {
        NSLog(@"no file by that name");
    }
}

//遍历文件夹获得文件夹大小，返回多少M
+ (float)folderSizeAtPath:(NSString*) folderPath {
    
    NSFileManager* manager = [NSFileManager defaultManager];
    
    if (![manager fileExistsAtPath:folderPath]) return 0;
    
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    
    NSString* fileName;
    
    long long folderSize = 0;
    
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        
        NSString* fileAbsolutePath = [folderPath  stringByAppendingPathComponent:fileName];
        
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
        
    }
    
    return folderSize/(1024.0*1024.0);
}

+ (long long)fileSizeAtPath:(NSString*) filePath{
    
    NSFileManager* manager = [NSFileManager defaultManager];
    
    if ([manager fileExistsAtPath:filePath]){
        
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
        
    }
    
    return 0;
    
}

//+ (NSString *)getSDWebImageCache {
//    NSUInteger size = [[SDImageCache sharedImageCache] totalDiskSize];
//    float tmpSize = size/1000/1000;
//    NSString *clearCacheName = tmpSize >= 1 ? [NSString stringWithFormat:@"%.2fM",tmpSize] : [NSString stringWithFormat:@"%.2fK",tmpSize * 1024];
//    return clearCacheName;
//}
//
//+ (void)clearSDWebImageCache:(void(^)(void))clearBlock {
//    [[SDImageCache sharedImageCache] clearWithCacheType:SDImageCacheTypeAll completion:^{
//        if (clearBlock) {
//            clearBlock();
//        }
//    }];
//}

@end
