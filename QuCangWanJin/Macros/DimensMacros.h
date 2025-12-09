#ifndef DimensMacros_h
#define DimensMacros_h
#import "CXFactory.h"


#define SCREEN_BOUNDS    [UIScreen mainScreen].bounds
#define SCREEN_WIDTH     [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT    [UIScreen mainScreen].bounds.size.height
#define KWidth  SCREEN_WIDTH
#define KHeight SCREEN_HEIGHT
#define KBounds SCREEN_BOUNDS



#define NavHeight (STATUS_BAR_HEIGHT + 44.f)

//状态栏高度


//状态栏的高度
#ifdef __IPHONE_13_0 //判断是否是13以上系统
#define STATUS_BAR_HEIGHT [[UIApplication sharedApplication] windows].firstObject.windowScene.statusBarManager.statusBarFrame.size.height
#else
#define STATUS_BAR_HEIGHT [[UIApplication sharedApplication] statusBarFrame].size.height
#endif

//判断是否是iPhone X
#define iPhoneX (STATUS_BAR_HEIGHT > 20.f ? YES : NO)
//导航栏高度
#define NAVIGATION_BAR_HEIGHT (iPhoneX ? 88.f : 64.f)
//导航栏实际高度
#define NAVBAR_HEIGHT NAVIGATION_BAR_HEIGHT - STATUS_BAR_HEIGHT
//tabBar高度
#define TABBAR_HEIGHT (iPhoneX ? (49.f + 34.f) : 49.f)
//Home indicator高度
#define HOME_INDICATOR_HEIGHT (iPhoneX ? 34.f : 0.f)

#define kViewHeight1 KHeight - NAVIGATION_BAR_HEIGHT
#define kViewHeight2 KHeight - NAVIGATION_BAR_HEIGHT - TABBAR_HEIGHT
#define kViewHeight3 KHeight - NAVIGATION_BAR_HEIGHT - HOME_INDICATOR_HEIGHT

#endif
