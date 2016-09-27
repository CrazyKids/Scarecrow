//
//  ADLocalWebViewController.m
//  Scarecrow
//
//  Created by VictorZhang on 22/09/2016.
//  Copyright © 2016 duanhongjin. All rights reserved.
//

#import "ADLocalWebViewController.h"
#import "ADLocalWebViewModel.h"

@interface ADLocalWebViewController ()

@property (strong, nonatomic, readonly) ADLocalWebViewModel *viewModel;

@end

@implementation ADLocalWebViewController

@dynamic viewModel;

+ (__kindof ADViewController *)viewController {
    ADLocalWebViewController *vc = [[ADLocalWebViewController alloc] init];
    return vc;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.webView = [[WKWebView alloc]initWithFrame:self.view.bounds];
    self.webView.backgroundColor = [UIColor clearColor];
    self.webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.webView loadHTMLString:[NSString stringWithFormat:@"<html><body><h1 style=\"font-size:50px;\">%@</h1></body></html>", self.viewModel.htmlValue] baseURL:nil];
    [self.view addSubview:self.webView];
}

@end
