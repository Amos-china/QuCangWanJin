//
//  ASBaseView.m
//  AnswerQuestions
//
//  Created by 陈志远 on 2025/10/10.
//

#import "QCBaseView.h"

@implementation QCBaseView



- (instancetype)initWithXib {
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] objectAtIndex:0];
}

+ (instancetype)initWithXib {
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil] objectAtIndex:0];
}

@end
