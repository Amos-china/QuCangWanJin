//
//  AQWebViewController.m
//  AnswerQuestions
//
//  Created by 陈志远 on 2025/7/30.
//

#import "AQWebViewController.h"
#import <WebKit/WebKit.h>

@interface AQWebViewController ()

@property (weak, nonatomic) IBOutlet WKWebView *webView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation AQWebViewController

- (instancetype)init {
    if (self = [super init]) {
        self.modalPresentationStyle = UIModalPresentationFullScreen;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib
    
    self.titleLabel.text = self.titleText;
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.url]];
    [self.webView loadRequest:request];
}

- (IBAction)backButtonAction:(id)sender {
    if (self.navigationController) {
        [self popViewController];
    }else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

@end
