//
//  QCGameMainTabbarController.m
//  QuCangWanJin
//
//  Created by 陈志远 on 2025/12/2.
//

#import "QCGameMainTabbarController.h"
#import "QCBaseNavigationController.h"
#import "QCGameMineViewController.h"
#import "QCGameMainViewController.h"

@interface QCGameMainTabbarController ()

@end

@implementation QCGameMainTabbarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configTabbar];
    
    [self createDefaultsControllers];
    
}


- (void)createDefaultsControllers {
    QCGameMainViewController *gameMainVc = [[QCGameMainViewController alloc] init];
    QCGameMineViewController *gameMineVc = [[QCGameMineViewController alloc] init];
    [self tabbarAddChildController:gameMainVc
                             title:@"猜歌"
                         imageName:@"tabbar_cg_n"
                   selectImageName:@"tabbar_cg_s"];
    
    [self tabbarAddChildController:gameMineVc
                             title:@"我的"
                         imageName:@"tabbar_wd_n"
                   selectImageName:@"tabbar_wd_s"];
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


@end
