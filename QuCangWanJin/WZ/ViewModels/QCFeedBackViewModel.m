//
//  QCFeedBackViewModel.m
//  QuCangWanJin
//
//  Created by 陈志远 on 2025/12/10.
//

#import "QCFeedBackViewModel.h"
#import "AQService+Complaint.h"
@interface QCFeedBackViewModel ()

@property (nonatomic, strong) QCFeedBackRootModel *rootModel;
@property (nonatomic, strong) QCFeedBackItemModel *selectItemModel;
@property (nonatomic, copy) NSString *base64Image;

@end

@implementation QCFeedBackViewModel

- (instancetype)init {
    self  = [super init];
    if (self) {
        [self loadData];
    }
    return self;
}

- (void)loadData {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"complaint_list" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSDictionary *rootDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
    self.rootModel = [QCFeedBackRootModel modelWithkeyValues:rootDict];
}

- (NSInteger)tableViewRows {
    return self.rootModel.feedback_list.count;
}

- (QCFeedBackItemModel *)tableViewItemWithRow:(NSInteger)row {
    return self.rootModel.feedback_list[row];
}

- (void)tableViewSelectItemWithRow:(NSInteger)row {
    if (self.selectItemModel) {
        self.selectItemModel.select = NO;
    }
    self.selectItemModel = [self tableViewItemWithRow:row];
    self.selectItemModel.select = YES;
}

- (void)selectImageWithBase64:(NSString *)base64 {
    self.base64Image = base64;
}

- (void)deleteImage {
    self.base64Image = @"";
}

- (BOOL)checkItemModel {
    return self.selectItemModel != nil;
}

- (void)submitWithContent:(NSString *)content
                  success:(OnSuccess)success
                    error:(QCHTTPRequestResponseErrorBlock)error {
    [QCService requestComplaintTypeId:self.selectItemModel.complaintId
                              content:content
                                  pic:self.base64Image
                              success:^(id  _Nonnull data) {
        success();
    } error:error];
}

@end
