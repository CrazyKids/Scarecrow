//
//  ADReposInfoViewController.m
//  Scarecrow
//
//  Created by duanhongjin on 16/9/19.
//  Copyright © 2016年 duanhongjin. All rights reserved.
//

#import "ADReposInfoViewController.h"
#import "ADReposInfoViewModel.h"

@interface ADReposInfoViewController ()

@property (strong, nonatomic, readonly) ADReposInfoViewModel *viewModel;

@end

@implementation ADReposInfoViewController

@dynamic viewModel;

+ (ADViewController *)viewController {
    return [ADReposInfoViewController new];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = self.viewModel.repos.name;
}

-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    self.viewModel.titleViewType = ADTitleViewTypeDefault;
}

@end
