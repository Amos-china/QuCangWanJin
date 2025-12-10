#import "QCDatabaseManager.h"

@implementation QCDatabaseManager

+ (instancetype)sharedManager {
    static QCDatabaseManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
        [sharedInstance setupDatabase];
    });
    return sharedInstance;
}


- (void)setupDatabase {
    // 获取Documents目录路径
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *dbPath = [documentsPath stringByAppendingPathComponent:@"group_messages.db"];
    
    // 创建数据库队列
    self.databaseQueue = [FMDatabaseQueue databaseQueueWithPath:dbPath];
}

- (BOOL)createTables {
    __block BOOL success = YES;
    
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        NSString *sql = @"CREATE TABLE IF NOT EXISTS group_messages ("
                        "id INTEGER PRIMARY KEY AUTOINCREMENT, "
                        "messageId TEXT UNIQUE, "
                        "time TEXT, "
                        "groupId INTEGER, "
                        "face TEXT, "
                        "nickname TEXT, "
                        "type INTEGER, "
                        "content TEXT, "
                        "collectStatus INTEGER, "
                        "createdTime REAL DEFAULT (datetime('now','localtime'))"
                        ")";
        
        if (![db executeUpdate:sql]) {
            NSLog(@"创建表失败: %@", db.lastError);
            success = NO;
        } else {
            NSLog(@"创建表成功");
        }
    }];
    
    return success;
}

- (void)closeDatabase {
    [self.databaseQueue close];
    self.databaseQueue = nil;
}

@end
