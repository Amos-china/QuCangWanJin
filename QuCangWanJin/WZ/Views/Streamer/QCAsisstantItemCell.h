#import "QCBaseCollectionViewCell.h"
#import "QCAssistantModel.h"
NS_ASSUME_NONNULL_BEGIN

typedef void(^SelectButtonActionCallBack)(QCAssistantModel *);

@interface QCAsisstantItemCell : QCBaseCollectionViewCell

@property (nonatomic, strong) QCAssistantModel *assistantModel;

@property (nonatomic, copy) SelectButtonActionCallBack selectButtonActionCallBack;



@end

NS_ASSUME_NONNULL_END
