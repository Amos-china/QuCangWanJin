//
//  AQMessageDBManager.m
//  AnswerQuestions
//
//  Created by 陈志远 on 2025/11/22.
//

#import "QCGroupMessageDao.h"
#import "QCDatabaseManager.h"

@implementation QCGroupMessageDao

+ (instancetype)sharedDao {
    static QCGroupMessageDao *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[super allocWithZone:NULL] init];
    });
    return instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [self sharedDao];
}

// 重写方法【必不可少】
- (id)copyWithZone:(nullable NSZone *)zone{
    return self;
}

- (BOOL)insertMessage:(QCGroupMessageModel *)message {
    __block BOOL success = NO;
   [[QCDatabaseManager sharedManager].databaseQueue inDatabase:^(FMDatabase *db) {
       NSString *sql = @"INSERT OR REPLACE INTO group_messages "
                       "(messageId, time, groupId, face, nickname, type, content, collectStatus) "
                       "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
       
       success = [db executeUpdate:sql,
                  message.messageId ?: @"",
                  message.time ?: @"",
                  @(message.groupId),
                  message.face ?: @"",
                  message.nickname ?: @"",
                  @(message.type),
                  message.content ?: @"",
                  @(message.collectStatus)];
       
       if (!success) {
           NSLog(@"插入消息失败: %@", db.lastError);
       }
   }];
   
   return success;
}

- (BOOL)insertMessages:(NSArray<QCGroupMessageModel *> *)messages {
    __block BOOL success = YES;
     
     [[QCDatabaseManager sharedManager].databaseQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
         for (QCGroupMessageModel *message in messages) {
             if (message.type != 3) {
                 NSString *sql = @"INSERT OR REPLACE INTO group_messages "
                                 "(messageId, time, groupId, face, nickname, type, content, collectStatus) "
                                 "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
                 
                 BOOL result = [db executeUpdate:sql,
                                message.messageId ?: @"",
                                message.time ?: @"",
                                @(message.groupId),
                                message.face ?: @"",
                                message.nickname ?: @"",
                                @(message.type),
                                message.content ?: @"",
                                @(message.collectStatus)];
                 
                 if (!result) {
                     NSLog(@"批量插入消息失败: %@", db.lastError);
                     success = NO;
                     *rollback = YES;
                     break;
                 }
             }
         }
     }];
     
     return success;
}

#pragma mark - 删
- (BOOL)deleteMessageById:(NSString *)messageId {
    __block BOOL success = NO;
    
    [[QCDatabaseManager sharedManager].databaseQueue inDatabase:^(FMDatabase *db) {
        NSString *sql = @"DELETE FROM group_messages WHERE messageId = ?";
        success = [db executeUpdate:sql, messageId];
        
        if (!success) {
            NSLog(@"删除消息失败: %@", db.lastError);
        }
    }];
    
    return success;
}

- (BOOL)deleteMessagesByGroupId:(NSInteger)groupId {
    __block BOOL success = NO;
    
    [[QCDatabaseManager sharedManager].databaseQueue inDatabase:^(FMDatabase *db) {
        NSString *sql = @"DELETE FROM group_messages WHERE groupId = ?";
        success = [db executeUpdate:sql, @(groupId)];
        
        if (!success) {
            NSLog(@"删除群组消息失败: %@", db.lastError);
        }
    }];
    
    return success;
}

- (BOOL)deleteAllMessages {
    __block BOOL success = NO;
    
    [[QCDatabaseManager sharedManager].databaseQueue inDatabase:^(FMDatabase *db) {
        NSString *sql = @"DELETE FROM group_messages";
        success = [db executeUpdate:sql];
        
        if (!success) {
            NSLog(@"清空消息失败: %@", db.lastError);
        }
    }];
    
    return success;
}

#pragma mark - 改
- (BOOL)updateMessage:(QCGroupMessageModel *)message {
    __block BOOL success = NO;
    
    [[QCDatabaseManager sharedManager].databaseQueue inDatabase:^(FMDatabase *db) {
        NSString *sql = @"UPDATE group_messages SET "
                        "time = ?, groupId = ?, face = ?, nickname = ?, "
                        "type = ?, content = ?, collectStatus = ? "
                        "WHERE messageId = ?";
        
        success = [db executeUpdate:sql,
                   message.time ?: @"",
                   @(message.groupId),
                   message.face ?: @"",
                   message.nickname ?: @"",
                   @(message.type),
                   message.content ?: @"",
                   @(message.collectStatus),
                   message.messageId ?: @""];
        
        if (!success) {
            NSLog(@"更新消息失败: %@", db.lastError);
        }
    }];
    
    return success;
}

- (BOOL)updateCollectStatus:(NSInteger)status forMessageId:(NSString *)messageId {
    __block BOOL success = NO;
    
    [[QCDatabaseManager sharedManager].databaseQueue inDatabase:^(FMDatabase *db) {
        NSString *sql = @"UPDATE group_messages SET collectStatus = ? WHERE messageId = ?";
        success = [db executeUpdate:sql, @(status), messageId];
        
        if (!success) {
            NSLog(@"更新领取状态失败: %@", db.lastError);
        }
    }];
    
    return success;
}


#pragma mark - 查
- (QCGroupMessageModel *)getMessageById:(NSString *)messageId {
    __block QCGroupMessageModel *message = nil;
    
    [[QCDatabaseManager sharedManager].databaseQueue inDatabase:^(FMDatabase *db) {
        NSString *sql = @"SELECT * FROM group_messages WHERE messageId = ?";
        FMResultSet *rs = [db executeQuery:sql, messageId];
        
        if ([rs next]) {
            message = [self messageFromResultSet:rs];
        }
        
        [rs close];
    }];
    
    return message;
}

- (NSArray<QCGroupMessageModel *> *)getMessagesByGroupId:(NSInteger)groupId {
    return [self getMessagesByGroupId:groupId limit:0 offset:0];
}

- (NSArray<QCGroupMessageModel *> *)getMessagesByGroupId:(NSInteger)groupId limit:(NSInteger)limit offset:(NSInteger)offset {
    __block NSMutableArray *messages = [NSMutableArray array];
    
    [[QCDatabaseManager sharedManager].databaseQueue inDatabase:^(FMDatabase *db) {
        NSString *sql = @"SELECT * FROM group_messages WHERE groupId = ? ORDER BY createdTime ASC";
        
        if (limit > 0) {
            sql = [sql stringByAppendingFormat:@" LIMIT %ld OFFSET %ld", (long)limit, (long)offset];
        }
        
        FMResultSet *rs = [db executeQuery:sql, @(groupId)];
        
        while ([rs next]) {
            QCGroupMessageModel *message = [self messageFromResultSet:rs];
            [messages addObject:message];
        }
        
        [rs close];
    }];
    
    return [messages copy];
}

- (NSArray<QCGroupMessageModel *> *)getAllMessages {
    __block NSMutableArray *messages = [NSMutableArray array];
    
    [[QCDatabaseManager sharedManager].databaseQueue inDatabase:^(FMDatabase *db) {
        NSString *sql = @"SELECT * FROM group_messages ORDER BY createdTime ASC";
        FMResultSet *rs = [db executeQuery:sql];
        
        while ([rs next]) {
            QCGroupMessageModel *message = [self messageFromResultSet:rs];
            [messages addObject:message];
        }
        
        [rs close];
    }];
    
    return [messages copy];
}

- (NSInteger)getMessageCountByGroupId:(NSInteger)groupId {
    __block NSInteger count = 0;
    
    [[QCDatabaseManager sharedManager].databaseQueue inDatabase:^(FMDatabase *db) {
        NSString *sql = @"SELECT COUNT(*) as count FROM group_messages WHERE groupId = ?";
        FMResultSet *rs = [db executeQuery:sql, @(groupId)];
        
        if ([rs next]) {
            count = [rs intForColumn:@"count"];
        }
        
        [rs close];
    }];
    
    return count;
}

#pragma mark - 工具方法
- (QCGroupMessageModel *)messageFromResultSet:(FMResultSet *)rs {
    QCGroupMessageModel *message = [[QCGroupMessageModel alloc] init];
    
    message.messageId = [rs stringForColumn:@"messageId"];
    message.time = [rs stringForColumn:@"time"];
    message.groupId = [rs intForColumn:@"groupId"];
    message.face = [rs stringForColumn:@"face"];
    message.nickname = [rs stringForColumn:@"nickname"];
    message.type = [rs intForColumn:@"type"];
    message.content = [rs stringForColumn:@"content"];
    message.collectStatus = [rs intForColumn:@"collectStatus"];
    
    return message;
}

@end
