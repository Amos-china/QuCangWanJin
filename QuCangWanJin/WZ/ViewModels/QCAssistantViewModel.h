#import "QCBaseViewModel.h"
#import "QCAssistantModel.h"
#import "QCAssistantUnlockModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface QCAssistantViewModel : QCBaseViewModel

@property (nonatomic, strong) NSMutableArray<QCAssistantModel *> *assistantList;
@property (nonatomic, strong) QCAssistantModel *chooseAssistantModel;
@property (nonatomic, strong) QCAssistantUnlockModel *unlockModel;


- (void)requestGameAssistantList:(OnSuccess)success
                         onError:(QCHTTPRequestResponseErrorBlock)onError;

- (void)requestGameAssistantUnlock:(NSString *)assistantId
                         onSuccess:(OnSuccess)success
                           onError:(QCHTTPRequestResponseErrorBlock)onError;

- (void)requestChooseAssistant:(NSString *)assistantId
                     onSuccess:(OnSuccess)success
                       onError:(QCHTTPRequestResponseErrorBlock)onError;


- (NSArray<NSIndexPath *> *)unLockReloadUiAtIndexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
