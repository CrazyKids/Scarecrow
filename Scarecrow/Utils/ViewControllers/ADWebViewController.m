//
//  ADWebViewController.m
//  Scarecrow
//
//  Created by duanhongjin on 8/12/16.
//  Copyright © 2016 duanhongjin. All rights reserved.
//

#import "ADWebViewController.h"
#import "ADWebViewModel.h"

@interface ADWebViewController ()

@property (strong, nonatomic, readonly) ADWebViewModel *viewModel;

@end

@implementation ADWebViewController

@dynamic viewModel;

+ (__kindof ADViewController *)viewController {
    ADWebViewController *vc = [[ADWebViewController alloc]initWithNibName:@"ADWebViewController" bundle:nil];
    
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = YES;
    
    RACSignal *didFinishLoadSignal   = [self rac_signalForSelector:@selector(webViewDidFinishLoad:) fromProtocol:@protocol(UIWebViewDelegate)];
    RACSignal *didFailLoadLoadSignal = [self rac_signalForSelector:@selector(webView:didFailLoadWithError:) fromProtocol:@protocol(UIWebViewDelegate)];
    
    ADTitleViewType type = self.viewModel.titleViewType;
    RAC(self.viewModel, titleViewType) = [[RACSignal merge:@[didFinishLoadSignal, didFailLoadLoadSignal]] mapReplace:@(type)];
    
    NSParameterAssert(self.viewModel.request);
    
    WKWebViewConfiguration *configuration = [WKWebViewConfiguration new];
    configuration.preferences = [WKPreferences new];
    configuration.userContentController = [WKUserContentController new];
    
    self.webView = [[WKWebView alloc]initWithFrame:self.view.bounds configuration:configuration];
    self.webView.backgroundColor = [UIColor clearColor];
    self.webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.webView.navigationDelegate = self;
    [self.view addSubview:self.webView];
    
    [self.webView loadRequest:self.viewModel.request];
}

- (void)dealloc {
    self.webView.navigationDelegate = nil;
}

#pragma mark - WKNavigationDelegate

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSString *scheme = webView.URL.scheme;
    if ([scheme isEqualToString:@"https"] || [scheme isEqualToString:@"http"]) {
        self.viewModel.titleViewType = ADTitleViewTypeLoading;
    }
    
    decisionHandler(WKNavigationActionPolicyAllow);
}

-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [webView evaluateJavaScript:@"document.title" completionHandler:^(NSString * _Nullable title, NSError * _Nullable error) {
        self.viewModel.titleViewType = ADTitleViewTypeDefault;
        self.navigationItem.title = title.stringByRemovingPercentEncoding;
    }];
}

#pragma mark - UIViewControllerRotation

- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

@end
