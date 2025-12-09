#ifndef UtilsMacros_h
#define UtilsMacros_h

#import "AppDelegate.h"
//#import ""

#define APPDELEGATE ((AppDelegate *)[[UIApplication sharedApplication] delegate])
#define WINDOW [UIApplication sharedApplication].windows[0]
#define KEYWINDOW [Functions topWindow]
#define USERDEFAULT [NSUserDefaults standardUserDefaults]
// ----- 适配 ------
#define aufont(a) (a / 375.0 * KWidth)
//字体大小
#pragma mark - ------------------- Font -------------------
#define FONT(size) [UIFont systemFontOfSize:size]

#define HEIGHT(f) f * ([UIScreen mainScreen].bounds.size.width/375.0)
#pragma mark - ---------------- Memory ----------------
#define WEAK(weakSelf) __weak typeof(self) weakSelf = self;
#define STRONG(strongSelf,weakSelf) __strong typeof(weakSelf) strongSelf = weakSelf;
#pragma mark - ------------------- 字体 -------------------
#define FONT(size) [UIFont systemFontOfSize:size]
#define R_Font(a) [UIFont fontWithName:@"PingFangSc-Regular" size:aufont(a)]
#define M_Font(a) [UIFont fontWithName:@"PingFangSc-Medium" size:aufont(a)]
#define B_Font(a) [UIFont fontWithName:@"PingFangSc-Bold" size:aufont(a)]
#define APPFONT(a) [UIFont fontWithName:@"Resource-Han-Rounded-CN-Bold" size:aufont(a)]

#pragma mark - -------------------- Log --------------------
#if DEBUG
#define NSLog(FORMAT, ...) fprintf(stderr,"-------------------------- [NSLog] -------------------------- \n[D]:%s\n[T]:%s\n[F]:%s\n[M]:%s\n[L]:%d\n[C]:%s\n", __DATE__, __TIME__, __FILE__,__FUNCTION__, __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#else
#define NSLog(FORMAT, ...) nil
#endif

#if DEBUG
#define HRLog(FORMAT, ...) fprintf(stderr,"-------------------------- [NSLog] -------------------------- \n%s\n",[[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#else
#define HRLog(FORMAT, ...) nil
#endif

#pragma mark - ------------------- 字符串 -------------------
#define SF(...) [NSString stringWithFormat:__VA_ARGS__]
#define NIL(string) (string == nil || (NSNull *)string == [NSNull null] || [string isEqualToString:@""])
#define LOCAL_STRING(x, ...) NSLocalizedString(x, nil)


//UINIB
#define MXENIB(nibName) [UINib nibWithNibName:(nibName) bundle:nil]

// View 圆角
#define ViewRadius(View, Radius)\
\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES]

// View 圆角和加边框
#define ViewBorderRadius(View, Radius, Width, Color)\
\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES];\
[View.layer setBorderWidth:(Width)];\
[View.layer setBorderColor:[Color CGColor]]

/// 判断字符串是否为空或者为空字符串 YES:空的
#define STR_Is_NullOrEmpty(str) (str == nil || [str isEqualToString:@""] || [str isEqual:[NSNull null]])

/// URL中文转码
#define URLEncoding(str) [str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]

// 图片
#define IMG(name) [UIImage imageNamed:name]
/// 存储用信息的key
///
#endif /* ProjectCommon_h */
