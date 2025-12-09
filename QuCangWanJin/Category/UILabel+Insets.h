//
//  UILabel+Insets.h
//  MelonTheater
//
//  Created by 陈志远 on 2024/1/15.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UILabel (Insets)

/**
和UITextView相似，内边距属性
控制字体与控件边界的间隙
*/
@property (nonatomic, assign) UIEdgeInsets contentInsets;

@end

NS_ASSUME_NONNULL_END
