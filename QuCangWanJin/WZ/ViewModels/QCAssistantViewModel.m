#import "QCAssistantViewModel.h"
#import "AQService+Game.h"

@implementation QCAssistantViewModel

- (NSMutableArray<QCAssistantModel *> *)assistantList {
    if (!_assistantList) {
        _assistantList = [NSMutableArray array];
    }
    return _assistantList;
}

- (void)requestGameAssistantList:(OnSuccess)success
                         onError:(QCHTTPRequestResponseErrorBlock)onError {
    __weak typeof(self) weakSelf = self;
    [QCService requestGameAssistant:self.page
                                        success:^(id  _Nonnull data) {
        NSArray<QCAssistantModel *> *assistants = [QCAssistantModel mj_objectArrayWithKeyValuesArray:data];
//        for (AQAssistantModel *model in assistants) {
//            if (model.state == 0) {
//                model.state = 3;
//                break;
//            }
//        }
        [weakSelf.assistantList addObjectsFromArray:assistants];
        success();
    } error:onError];
}

- (void)requestChooseAssistant:(NSString *)assistantId
                     onSuccess:(OnSuccess)success
                       onError:(QCHTTPRequestResponseErrorBlock)onError {
    __weak typeof(self) weakSelf = self;
    [QCService requestGameClooseAssistant:assistantId
                                              success:^(id  _Nonnull data) {
        weakSelf.chooseAssistantModel = [QCAssistantModel modelWithkeyValues:data];
        success();
    } error:onError];
}

- (void)requestGameAssistantUnlock:(NSString *)assistantId
                         onSuccess:(OnSuccess)success
                           onError:(QCHTTPRequestResponseErrorBlock)onError {
    [QCService requestGameAssistantUnlock:assistantId
                                              success:^(id  _Nonnull data) {
        success();
    } error:onError];
}


- (NSArray<NSIndexPath *> *)unLockReloadUiAtIndexPath:(NSIndexPath *)indexPath {
    QCAssistantModel *model = self.assistantList[indexPath.row];
    model.state = 1;
    NSInteger nextRow = indexPath.row + 1;
    NSArray<NSIndexPath *> *reloadRows = @[indexPath];
    if (nextRow < self.assistantList.count) {
        QCAssistantModel *nextModel = self.assistantList[nextRow];
        nextModel.state = 3;
        NSIndexPath *nextIndexPath = [NSIndexPath indexPathForRow:nextRow inSection:0];
        reloadRows = @[indexPath,nextIndexPath];
    }
    return reloadRows;
}

@end
