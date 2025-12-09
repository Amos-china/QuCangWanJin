#import "QCBaseViewModel.h"
#import "QCMusicIndexModel.h"
#import "QCCollectGoldModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger,QCCollectGoldType){
    QCCollectGoldTypeMax,
    QCCollectGoldTypeMin,
    QCCollectGoldTypeAuto
};

@interface QCGameHomeMusicViewModel : QCBaseViewModel


@property (nonatomic, strong) QCMusicIndexModel *answerIndexModel;
@property (nonatomic, strong) QCCollectGoldModel *collectGoldModel;
@property (nonatomic, assign) QCCollectGoldType collectGoldType;


@property (nonatomic, copy) NSAttributedString *progressViewMoneyAttributedString;
@property (nonatomic, copy) NSAttributedString *progressViewGameStageAttributedString;
- (NSAttributedString *)progressLabelAttributedStringAtMax:(BOOL)max;

- (NSInteger)getCurrenStageNum;
- (BOOL)checkNewUser;
- (BOOL)isCheckChooseQuestionRightAtIndex:(NSInteger)index;
- (float)progressValueAtMax:(BOOL)max;
- (BOOL)checkRelations;
- (BOOL)checkCollectAutoGold;
- (BOOL)showHbCashPopView;
- (BOOL)canShowNewUserGuide;
- (void)setShowNewUserKey;
- (NSInteger)getRightAnswerIndex;
- (BOOL)checkCollectShowNewUserController;
- (BOOL)canShowHBGroupButton;
- (BOOL)checkShowNewUserStreamerGuide;
- (NSString *)cashOutPopText;
- (BOOL)canShowCashOutPopView;
- (BOOL)checkShowNewUserRelationsGuideToast;
- (BOOL)canShowCashWithdrawalView;
//通关提示
- (void)showNewUserRelationsGuideToast;
- (NSString *)subGameNumText;


- (BOOL)canShowWechatCashToast;
- (BOOL)canPushCashHb;
- (void)startTimerHandler:(void(^)(NSString *))handler;
- (void)endTimer;

- (void)requestGameIndex:(NSInteger)skip
               onSuccess:(OnSuccess)onSuccess
                 onError:(QCHTTPRequestResponseErrorBlock)onSrror;

- (void)requestCollectNewUserGold:(OnSuccess)success onError:(QCHTTPRequestResponseErrorBlock)onError;

- (void)requestMaxCollect:(QCAdEcpmInfoModel *)infoModel
                    success:(OnSuccess)success
                      error:(QCHTTPRequestResponseErrorBlock)error;

- (void)requestMinCollectSuccess:(OnSuccess)success error:(QCHTTPRequestResponseErrorBlock)error;

- (void)requestAutoCollectGold:(QCAdEcpmInfoModel *)infoModel
                       Success:(OnSuccess)success
                         error:(QCHTTPRequestResponseErrorBlock)error;

@end

NS_ASSUME_NONNULL_END
