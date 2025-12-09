#import "QCBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface QCXJDetailModel : QCBaseModel

// 1.title 2.subtitle
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, copy) NSString *title;
//0.默认显示  1.正在进行 2.未到达
@property (nonatomic, assign) NSInteger status;

@property (nonatomic, copy) NSString *subTitle;
@property (nonatomic, copy) NSAttributedString *attTitle;

@property (nonatomic, copy) NSString *money;

@property (nonatomic, copy) NSString *time;

@property (nonatomic, assign) BOOL isShowDetail;

//cell类型 1.top 2.bottom 0.item
@property (nonatomic, assign) NSInteger cellType;

//弹窗显示的text
@property (nonatomic, copy) NSString *toastText;

@end

NS_ASSUME_NONNULL_END
