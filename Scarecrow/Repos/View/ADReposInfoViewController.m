//
//  ADReposInfoViewController.m
//  Scarecrow
//
//  Created by duanhongjin on 16/9/19.
//  Copyright © 2016年 duanhongjin. All rights reserved.
//

#import "ADReposInfoViewController.h"
#import "ADReposInfoViewModel.h"
#import "ADBarButtonItem.h"

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
    
    UIImage *image = [UIImage imageNamed:@"more"];
    self.navigationItem.rightBarButtonItem = [[ADBarButtonItem alloc]initWithImage:image style:UIBarButtonItemStylePlain target:self action:nil];
}

- (void)bindViewModel {
    [super bindViewModel];
    
    self.navigationItem.rightBarButtonItem.rac_command = self.viewModel.rightBarCommand;
}

-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    self.viewModel.titleViewType = ADTitleViewTypeDefault;
}

@end
