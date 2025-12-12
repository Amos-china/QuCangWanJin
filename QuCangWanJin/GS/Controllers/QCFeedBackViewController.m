#import "QCFeedBackViewController.h"
#import "QCPlaceholderTextView.h"
#import <MobileCoreServices/MobileCoreServices.h>
@interface QCFeedBackViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet QCPlaceholderTextView *textView;
@property (weak, nonatomic) IBOutlet UIImageView *feedImageView;

@end

@implementation QCFeedBackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    self.feedImageView.userInteractionEnabled = YES;
    [self.feedImageView addGestureRecognizer:tap];
}

- (void)tapAction:(UITapGestureRecognizer *)tap {
    [self openPhotoLibrary];
}

- (IBAction)backButtonAction:(id)sender {
    [self popViewController];
}


- (IBAction)submitButtonAction:(id)sender {
    NSString *text = self.textView.text;
    if (text.length == 0) {
        [self showToast:@"请输入您要反馈的内容"];
        return;
    }
    
    [self requestSubmit:text];
}

- (void)requestSubmit:(NSString *)text {
    __weak typeof(self) weakSelf = self;
    [self showHUD];
    [QCService requestWithType:MXEHttpRequestTypePost
                     urlString:@"https://qcwjios.txapk.com/api/check_user/problemFeedback"
                    parameters:@{@"text":text}
                  successBlock:^(NSDictionary * _Nonnull responseObject) {
        [weakSelf dismissHUD];
        QCRootModel *rootModel = [QCRootModel modelWithkeyValues:responseObject];
        if (rootModel.code == 1) {
            [weakSelf showAlertControllerMessage:@"我们已经收到了您的反馈信息。" doneButtonAction:^{
                [weakSelf popViewController];
            } cancelButtonAction:^{
                [weakSelf popViewController];
            }];
        }
    } failureBlock:^(NSError * _Nonnull error) {
        [weakSelf showToast:error.localizedDescription];
    }];
}

- (IBAction)deleteImageButton:(id)sender {
    self.feedImageView.image = [UIImage imageNamed:@"wtfk_add_im_btn"];
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
    self.feedImageView.image = chosenImage;

    
    // 3. 关闭相册
    [picker dismissViewControllerAnimated:YES completion:nil];
}

// 用户点取消
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}


@end
