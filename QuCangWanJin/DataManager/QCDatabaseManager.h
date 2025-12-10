#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QCDatabaseManager : NSObject

@property (nonatomic, strong) FMDatabaseQueue *databaseQueue;

+ (instancetype)sharedManager;

- (BOOL)createTables;
- (void)closeDatabase;

@end

NS_ASSUME_NONNULL_END
