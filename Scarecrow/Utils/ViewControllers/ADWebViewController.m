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
    
    self.webView.delegate = self;
    [self.webView loadRequest:self.viewModel.request];
}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if (navigationType == UIWebViewNavigationTypeOther) {
        if ([request.URL.scheme isEqualToString:@"https"] || [request.URL.scheme isEqualToString:@"http"]) {
            self.viewModel.titleViewType = ADTitleViewTypeLoading;
        }
    } else {
        [[UIApplication sharedApplication]openURL:request.URL];
    }
    
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    

}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSString *title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    self.title = title.stringByRemovingPercentEncoding;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error {
    
}

@end
