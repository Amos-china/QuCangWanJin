#import "QCMusicIndexModel.h"

@implementation QCMusicIndexModel

@end

@implementation QCMusicModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"option": [QCMusicOptionModel class]};
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
        @"music_id" : @"id"
    };
}

@end

@implementation QCMusicOptionModel



@end

@implementation QCGameIndexAssisTantPopModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
        @"assisTant_id" : @"id"
    };
}


@end


@implementation QCGameCashConditionModel



@end


@implementation QCGameIndexGameProgressModel



@end
