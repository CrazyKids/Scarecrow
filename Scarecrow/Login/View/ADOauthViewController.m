//
//  ADOauthViewController.m
//  Scarecrow
//
//  Created by duanhongjin on 8/12/16.
//  Copyright © 2016 duanhongjin. All rights reserved.
//

#import "ADOauthViewController.h"
#import "ADOauthViewModel.h"

@interface ADOauthViewController ()

@property (strong, nonatomic, readonly) ADOauthViewModel *viewModel;

@end

@implementation ADOauthViewController

@dynamic viewModel;

+ (ADViewController *)viewControllerWithViewModel:(ADViewModel *)viewModel {
    ADOauthViewController *vc = [[ADOauthViewController alloc]initWithNibName:@"ADOauthViewController" bundle:nil];
    viewModel.ownerVC = vc;
    [vc setValue:viewModel forKey:@"viewModel"];
    
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if ([request.URL.scheme isEqualToString:@"scarecrow"]) {
        NSDictionary *param = request.URL.oct_queryArguments;
        if ([param[@"state"] isEqualToString:self.viewModel.UUID] && self.viewModel.callback) {
            self.viewModel.callback(param[@"code"]);
        }
    } else if (navigationType == UIWebViewNavigationTypeOther) {
        return [super webView:webView shouldStartLoadWithRequest:request navigationType:navigationType];
    }
    
    return YES;
}

@end
