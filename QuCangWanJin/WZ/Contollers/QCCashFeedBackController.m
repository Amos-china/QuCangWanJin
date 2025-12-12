//
//  QCCashFeedBackController.m
//  QuCangWanJin
//
//  Created by 陈志远 on 2025/12/10.
//

#import "QCCashFeedBackController.h"
#import "QCPlaceholderTextView.h"
#import "QCFeedBackSelectTitleController.h"
#import <MobileCoreServices/MobileCoreServices.h>

@interface QCCashFeedBackController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet QCPlaceholderTextView *textView;
@property (weak, nonatomic) IBOutlet UIImageView *feedBackImageView;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (nonatomic, strong) QCFeedBackViewModel *viewModel;
@property (weak, nonatomic) IBOutlet UILabel *feedBackTitleLabel;

@end

@implementation QCCashFeedBackController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.viewModel = [[QCFeedBackViewModel alloc] init];
    __weak typeof(self) weakSelf = self;
    self.viewModel.callBack = ^(QCFeedBackItemModel * _Nonnull selectModel) {
        weakSelf.feedBackTitleLabel.text = selectModel.name;
    };
    
    UITapGestureRecognizer *imageTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapAction:)];
    [self.feedBackImageView addGestureRecognizer:imageTap];
}

- (void)imageTapAction:(UITapGestureRecognizer *)tap {
    [self openPhotoLibrary];
}

- (IBAction)backButtonAction:(id)sender {
    [self popViewController];
}

- (IBAction)selectTitleButtonAction:(id)sender {
    QCFeedBackSelectTitleController *vc = [[QCFeedBackSelectTitleController alloc] init];
    vc.viewModel = self.viewModel;
    [self pushViewController:vc];
}

- (IBAction)deleteButtonAction:(id)sender {
    self.feedBackImageView.image = [UIImage imageNamed:@"wtfk_add_im_btn"];
    [self.viewModel deleteImage];
}

- (IBAction)submitButtonAction:(id)sender {
    if (![self.viewModel checkItemModel]) {
        [self showToast:@"请选择您要反馈的标题"];
        return;
    }
    NSString *content = self.textView.text;
    if (content.length == 0) {
        [self showToast:@"请输入您要反馈的内容"];
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    [self showHUD];
    [self.viewModel submitWithContent:content success:^{
        [weakSelf showToast:@"提交成功,感谢您的支持"];
        [weakSelf popViewController];
    } error:^(NSInteger code, NSString * _Nonnull msg) {
        [weakSelf showToast:msg];
    }];
    
}

// 点击按钮或某个事件触发打开相册
- (void)openPhotoLibrary {
    
    // 1. 判断相册是否可用
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        NSLog(@"相册不可用");
        return;
    }
    
    // 2. 创建图片选择器
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;   // 相册
    // picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum; // 仅相机胶卷
    
    // 可选：是否允许编辑（选中后出现裁剪框）
    picker.allowsEditing = NO;   // YES = 选中后可以裁剪，NO = 直接返回原图
    
    // 可选：只允许选择图片（默认就是）
    picker.mediaTypes = @[(NSString *)kUTTypeImage];
    
    // 3. 弹出
    [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate

// 用户选完图片后回调（最常用）
- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    // 1. 取出图片
    UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
    
    // 2. 你可以在这里用这张图
    // 例如：显示到 UIImageView
    self.feedBackImageView.image = chosenImage;
    
    // 保存到沙盒、上传服务器等操作...
    // [self uploadImage:chosenImage];
    NSData *imageData = [self compressImageForUpload:chosenImage];
    [self.viewModel selectImageWithimageData:imageData];
    
    // 3. 关闭相册
    [picker dismissViewControllerAnimated:YES completion:nil];
}

// 用户点取消
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}


- (NSData *)compressImageForUpload:(UIImage *)image {
    NSData *data = UIImageJPEGRepresentation(image, 1.0);
    
    // 如果超过 2MB，就不断降低压缩比直到小于 2MB
    CGFloat compression = 0.9f;
    CGFloat maxCompression = 0.1f;
    NSUInteger maxFileSize = 2 * 1024 * 1024; // 2MB
    
    while (data.length > maxFileSize && compression > maxCompression) {
        compression -= 0.1;
        data = UIImageJPEGRepresentation(image, compression);
    }
    
    NSLog(@"最终图片大小：%.2f KB", data.length / 1024.0);
    return data;
}

@end
