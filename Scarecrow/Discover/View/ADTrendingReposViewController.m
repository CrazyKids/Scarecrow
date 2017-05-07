//
//  ADTrendingReposViewController.m
//  Scarecrow
//
//  Created by duanhongjin on 2017/3/23.
//  Copyright © 2017年 duanhongjin. All rights reserved.
//

#import "ADTrendingReposViewController.h"
#import "ADTrendingReposViewModel.h"

@interface ADTrendingReposViewController ()

@property (strong, nonatomic, readonly) ADTrendingReposViewModel *viewModel;

@end

@implementation ADTrendingReposViewController

@dynamic viewModel;

+ (ADViewController *)viewController {
    return [[ADTrendingReposViewController alloc]initWithNibName:@"ADTrendingReposViewController" bundle:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (UIEdgeInsets)contentInsets {
    return UIEdgeInsetsMake(0, 0, 16, 0);
}


@end
