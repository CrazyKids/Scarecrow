//
//  ADReposViewController.m
//  Scarecrow
//
//  Created by duanhongjin on 16/8/30.
//  Copyright © 2016年 duanhongjin. All rights reserved.
//

#import "ADReposViewController.h"
#import "ADReposViewModel.h"

@interface ADReposViewController ()

@property (strong, nonatomic, readonly) ADReposViewModel *viewModel;

@end

@implementation ADReposViewController

+ (ADViewController *)viewController {
    ADViewController *vc = [[UIStoryboard storyboardWithName:@"Repos" bundle:nil]instantiateInitialViewController];
    
    return vc;
}

@dynamic viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
}



@end
