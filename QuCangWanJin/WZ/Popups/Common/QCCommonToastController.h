#import "QCBasePopupViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger,CommonToastType) {
    CommonToastTypeHB,
    CommonToastTypeBalance,//余额不足
    CommonToastTypeLevel,
    CommonToastTypeActivity,
    CommonToastTypeSettingLevel,
    CommonToastTypeCashHB,
};

@interface QCCommonToastController : QCBasePopupViewController

@property (nonatomic, assign) CommonToastType toastType;
@property (nonatomic, copy) NSString *contentValue;
@property (nonatomic, copy) NSString *myLevel;

@end

NS_ASSUME_NONNULL_END
