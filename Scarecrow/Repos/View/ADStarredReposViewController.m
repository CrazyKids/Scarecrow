//
//  ADStarredReposViewController.m
//  Scarecrow
//
//  Created by duanhongjin on 9/9/16.
//  Copyright © 2016 duanhongjin. All rights reserved.
//

#import "ADStarredReposViewController.h"
#import "ADStarredReposViewModel.h"

@interface ADStarredReposViewController ()

@end

@implementation ADStarredReposViewController

+ (ADViewController *)viewController {
    return [[ADStarredReposViewController alloc]initWithNibName:@"ADStarredReposViewController" bundle:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Starred Repos";
}

@end
