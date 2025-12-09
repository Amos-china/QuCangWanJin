#import "QCBaseModel.h"

@implementation QCBaseModel

//将字典中的数组转换成数组模型
+ (NSDictionary *)mj_objectClassInArray {
//  return  @{@"friends" : [Friend class]}; 字典数组'friends'对应的模型是'Friend'
    return @{};
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{}

+ (id)modelWithkeyValues:(id)dict {
    return [self mj_objectWithKeyValues:dict];
}

- (NSString *)toJSONString {
    return [self mj_JSONString];
}

@end
