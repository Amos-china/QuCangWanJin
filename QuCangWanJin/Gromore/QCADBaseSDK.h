#import <Foundation/Foundation.h>
#import "QCAdEcpmInfoModel.h"
#import <BUAdSDK/BUAdSDK.h>
NS_ASSUME_NONNULL_BEGIN

typedef void(^CloseAdCompletionHandler)(QCAdEcpmInfoModel *ecpmInfoModel);
typedef void(^LoadFailCompletionHandler)(void);
typedef void(^LoadSuccessCompletionHandler)(BOOL);
typedef void(^ClickAdCompletionHandler)(void);

@interface QCADBaseSDK : NSObject

@property (nonatomic, strong) QCAdInfoConfig *config;
@property (nonatomic, copy) CloseAdCompletionHandler closeAdCompletionHandler;
@property (nonatomic, copy) LoadFailCompletionHandler loadFailCompletionHandler;
@property (nonatomic, copy) LoadSuccessCompletionHandler loadSuccessCompletionHandler;

@property (nonatomic, assign) BOOL isAdLoaded;
@property (nonatomic, assign) BOOL isAdShowing;

@property (nonatomic, assign) NSInteger touchCount;

- (void)loadAd;

- (BOOL)showAdWithInController:(UIViewController *)controller completionHander:(nonnull CloseAdCompletionHandler)completionHander;
- (BOOL)showSplashAdWithCompletionHander:(nonnull CloseAdCompletionHandler)completionHander;
- (BOOL)showBannerAdWithSuperView:(UIView *)superView controller:(UIViewController *)controller;

- (void)resetAdTouchCount;
- (void)didShowWith:(BUMRitInfo *)ritInfo;
- (void)didClickWith:(BUMRitInfo *)ritInfo;

- (QCAdEcpmInfoModel *)getEcpmInfoWith:(BUMRitInfo *)ritInfo;



@end

NS_ASSUME_NONNULL_END
