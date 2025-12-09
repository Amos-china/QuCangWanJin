#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, AQLoadingImageViewStatus) {
    GSLoadingImageViewStatusNormal,
    GSLoadingImageViewStatusLoading,
    GSLoadingImageViewStatusGray,
};

@interface QCLoadingImageView : UIImageView

@property (nonatomic, assign) AQLoadingImageViewStatus loadingStatus;

@end

NS_ASSUME_NONNULL_END
