//
//  AQMessageDBManager.h
//  AnswerQuestions
//
//  Created by 陈志远 on 2025/11/22.
//

#import <Foundation/Foundation.h>
#import "QCGroupMessageModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface QCGroupMessageDao : NSObject

+ (instancetype)sharedDao;

- (BOOL)insertMessage:(QCGroupMessageModel *)message;
- (BOOL)insertMessages:(NSArray<QCGroupMessageModel *> *)messages;

- (BOOL)deleteMessageById:(NSString *)messageId;
- (BOOL)deleteMessagesByGroupId:(NSInteger)groupId;
- (BOOL)deleteAllMessages;

- (BOOL)updateMessage:(QCGroupMessageModel *)message;
- (BOOL)updateCollectStatus:(NSInteger)status forMessageId:(NSString *)messageId;

- (QCGroupMessageModel *)getMessageById:(NSString *)messageId;
- (NSArray<QCGroupMessageModel *> *)getMessagesByGroupId:(NSInteger)groupId;
- (NSArray<QCGroupMessageModel *> *)getMessagesByGroupId:(NSInteger)groupId limit:(NSInteger)limit offset:(NSInteger)offset;
- (NSArray<QCGroupMessageModel *> *)getAllMessages;
- (NSInteger)getMessageCountByGroupId:(NSInteger)groupId;

- (QCGroupMessageModel *)messageFromResultSet:(FMResultSet *)rs;

@end

NS_ASSUME_NONNULL_END
