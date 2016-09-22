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

+ (ADViewController *)viewController {
    ADOauthViewController *vc = [[ADOauthViewController alloc]initWithNibName:@"ADOauthViewController" bundle:nil];
    
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - WKNavigationDelegate

-(void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    NSString *absoluteString = webView.URL.absoluteString;
    if ([absoluteString hasPrefix:github_callback_url]) {
        NSDictionary *param = webView.URL.oct_queryArguments;
        if ([param[@"state"] isEqualToString:self.viewModel.UUID] && self.viewModel.callback) {
            self.viewModel.callback(param[@"code"]);
        }
    }
}

#pragma mark - UIViewControllerRotation

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}


@end
