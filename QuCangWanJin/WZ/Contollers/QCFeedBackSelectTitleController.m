//
//  QCFeedBackSelectTitleController.m
//  QuCangWanJin
//
//  Created by 陈志远 on 2025/12/10.
//

#import "QCFeedBackSelectTitleController.h"

@interface QCFeedBackSelectTitleController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *listView;

@end

@implementation QCFeedBackSelectTitleController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.listView.rowHeight = 50.f;
}

- (IBAction)backButtonAction:(id)sender {
    [self popViewController];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.viewModel tableViewRows];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"DefaultCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    QCFeedBackItemModel *itemModel = [self.viewModel tableViewItemWithRow:indexPath.row];
    cell.textLabel.text = itemModel.name;
    cell.accessoryType = itemModel.select ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    QCFeedBackItemModel *itemModel = [self.viewModel tableViewItemWithRow:indexPath.row];
    [self.viewModel tableViewSelectItemWithRow:indexPath.row];
    !self.viewModel.callBack? : self.viewModel.callBack(itemModel);
    [self popViewController];
}

@end
