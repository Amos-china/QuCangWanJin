//
//  QCMainViewController.m
//  QuCangWanJin
//
//  Created by 陈志远 on 2025/11/20.
//

#import "QCMainTabbarViewController.h"
#import "QCHomeViewController.h"
#import "QCRedEnvelopeViewController.h"
#import "QCBaseNavigationController.h"
#import "QCMainTabbarViewController+ShowNotice.h"
@interface QCMainTabbarViewController ()<UITabBarControllerDelegate>

@property (nonatomic, assign) BOOL isUnlook;

@end

@implementation QCMainTabbarViewController


- (void)viewDidLoad {
    [super viewDidLoad];
   
    
    self.delegate = self;
    [self createConstrollers];

    [self configTabbar];
    
    [self addNotice];
}



- (void)createConstrollers {
    QCHomeViewController *homeVc = [[QCHomeViewController alloc] init];
    QCRedEnvelopeViewController *redEnvlopeVc = [[QCRedEnvelopeViewController alloc] init];
    
    [self tabbarAddChildController:homeVc
                             title:@"猜歌"
                         imageName:@"tabbar_cg_n"
                   selectImageName:@"tabbar_cg_s"];
    
    self.isUnlook = [self checkGuide];
    NSString *groupImage = self.isUnlook ? @"tabbar_ql_n" : @"tabbar_group_lock";
    [self tabbarAddChildController:redEnvlopeVc
                             title:@"群聊"
                         imageName:groupImage
                   selectImageName:@"tabbar_ql_s"];
}

- (void)tabbarAddChildController:(UIViewController *)controller
                           title:(NSString *)title
                       imageName:(NSString *)imageName
                 selectImageName:(NSString *)selectImageName {
    controller.tabBarItem.image = [IMG(imageName) imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    controller.tabBarItem.selectedImage = [IMG(selectImageName) imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    QCBaseNavigationController *nav = [[QCBaseNavigationController alloc] initWithRootViewController:controller];
    nav.navigationBar.hidden = YES;
    nav.tabBarItem.title = title;
    [self addChildViewController:nav];
}

- (void)configTabbar {
    UITabBarAppearance *apperarance = [[UITabBarAppearance alloc] init];
    [apperarance configureWithOpaqueBackground];
    apperarance.backgroundColor = UIColor.whiteColor;
    apperarance.backgroundEffect = nil;
    apperarance.shadowColor = UIColor.whiteColor;
   
    apperarance.stackedLayoutAppearance.normal.titleTextAttributes = @{NSForegroundColorAttributeName:ColorBBBBBB,
                                                                       NSFontAttributeName:APPFONT(10)};
    apperarance.stackedLayoutAppearance.selected.titleTextAttributes = @{NSForegroundColorAttributeName:AppColor,
                                                                         NSFontAttributeName:APPFONT(10)};
    self.tabBar.standardAppearance = apperarance;
    
    if(@available(iOS 15.0, *)) {
        self.tabBar.scrollEdgeAppearance = apperarance;
    }
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    NSInteger index = [self.viewControllers indexOfObject:viewController];
    if (index == 1) {
        BOOL unlook = [self checkGuide];
        if (!unlook) {
            [self showToast:@"达到第3关才能结果哦~"];
        }
        return unlook;
    }
    return YES;
}

- (BOOL)checkGuide {
    QCUserInfoModel *infoModel = [QCUserModel getUserModel].user_info;
    NSInteger guidePage = infoModel.guide_page_num;
    return guidePage == 4;
}

- (void)unLookTabbarItemGroupImage {
    if (!self.isUnlook) {
        UITabBarItem *thirdItem = self.tabBar.items[1];
        thirdItem.image = [[UIImage imageNamed:@"tabbar_ql_n"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        thirdItem.selectedImage = [[UIImage imageNamed:@"tabbar_ql_s"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
}

- (void)dealloc {
    [self removeNotice];
}

@end
