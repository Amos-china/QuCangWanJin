//
//  AQDatabaseManager.h
//  AnswerQuestions
//
//  Created by 陈志远 on 2025/11/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QCDatabaseManager : NSObject

@property (nonatomic, strong) FMDatabaseQueue *databaseQueue;

+ (instancetype)sharedManager;

- (BOOL)createTables;
- (void)closeDatabase;

@end

NS_ASSUME_NONNULL_END
