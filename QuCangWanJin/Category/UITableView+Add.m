//
//  UITableView+Add.m
//  Mudcon
//
//  Created by 陈志远 on 2025/6/19.
//

#import "UITableView+Add.h"

@implementation UITableView (Add)

- (void)registerNibClasses:(NSArray<Class> *)classes {
    for (Class cls in classes) {
        NSString *identifier = NSStringFromClass(cls);
        UINib *nib = [UINib nibWithNibName:identifier bundle:nil];
        [self registerNib:nib forCellReuseIdentifier:identifier];
    }
}

@end
