#import "QCAsisstionViewController.h"
#import "QCAsisstantItemCell.h"
#import "QCAssistantViewModel.h"
@interface QCAsisstionViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong) QCAssistantViewModel *viewMdoel;

@end

@implementation QCAsisstionViewController

- (QCAssistantViewModel *)viewMdoel {
    if (!_viewMdoel) {
        _viewMdoel = [[QCAssistantViewModel alloc] init];
    }
    return _viewMdoel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    
    [self setUp];
    
    [self getData];

}

- (void)getData {
    __weak typeof(self) weakSelf = self;
    [self showHUD];
    [self.viewMdoel requestGameAssistantList:^{
        [weakSelf dismissHUD];
        [weakSelf.collectionView reloadData];
    } onError:^(NSInteger code, NSString * _Nonnull msg) {
        if (code == SERVICE_REQUEST_ERROR_CODE) {
            [weakSelf dismissHUD];
            [weakSelf showReloadAlertMessage:msg doneButtonAction:^{
                [weakSelf getData];
            }];
        }
        [weakSelf showToast:msg];
    }];
}

- (void)clooseAssistant:(QCAssistantModel *)assistantModel indexPath:(NSIndexPath *)indexPath {
    __weak typeof(self) weakSelf = self;
    [self showHUD];
    [self.viewMdoel requestChooseAssistant:assistantModel.assistantId onSuccess:^{
        [weakSelf dismissHUD];
        !weakSelf.clooseCallBack ? :weakSelf.clooseCallBack(weakSelf.viewMdoel.chooseAssistantModel.assistant_pic);
        [weakSelf.navigationController popViewControllerAnimated:YES];
    } onError:^(NSInteger code, NSString * _Nonnull msg) {
        [weakSelf showToast:msg];
    }];
}

- (void)setUp {
    self.flowLayout.sectionInset = UIEdgeInsetsMake(30.f, 16.f, 30.f, 16.f);
    self.flowLayout.minimumLineSpacing = 14.f;
    self.flowLayout.minimumInteritemSpacing = 14.f;
    CGSize imageSize = [UIImage imageNamed:@"zb_item_bg"].size;
    CGFloat itemWidth = (KWidth - 32.f - 30.f) / 3;
    CGFloat itemHeight = itemWidth / (imageSize.width / imageSize.height);
    self.flowLayout.itemSize = CGSizeMake(itemWidth, itemHeight);
    
    NSString *cellName = NSStringFromClass(QCAsisstantItemCell.class);
    UINib *nib = [UINib nibWithNibName:cellName bundle:nil];
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:cellName];
    
    self.collectionView.layer.cornerRadius = 20.f;
    self.collectionView.layer.maskedCorners = kCALayerMinXMinYCorner | kCALayerMaxXMinYCorner;
    self.collectionView.layer.masksToBounds = YES;
    
}

- (IBAction)backButtonAction:(id)sender {
    [self popViewController];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.viewMdoel.assistantList.count;
}


- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellName = NSStringFromClass(QCAsisstantItemCell.class);
    QCAsisstantItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellName forIndexPath:indexPath];
    cell.assistantModel = self.viewMdoel.assistantList[indexPath.row];
    __weak typeof(self) weakSelf = self;
    cell.selectButtonActionCallBack = ^(QCAssistantModel * _Nonnull model) {
        [weakSelf clooseAssistant:model indexPath:indexPath];
    };
    return cell;
}



@end
