//
//  ADShowCaseReposViewController.m
//  Scarecrow
//
//  Created by duanhongjin on 2017/5/1.
//  Copyright © 2017年 duanhongjin. All rights reserved.
//

#import "ADShowCaseReposViewController.h"
#import "ADShowCaseReposViewModel.h"

@interface ADShowCaseReposViewController ()

@property (strong, nonatomic) ADShowCaseReposViewModel *viewModel;

@end

@implementation ADShowCaseReposViewController

@dynamic viewModel;

+ (ADViewController *)viewController {
    return [[ADShowCaseReposViewController alloc]initWithNibName:@"ADShowCaseReposViewController" bundle:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

@end
