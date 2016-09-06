//
//  ADPublicReposViewController.m
//  Scarecrow
//
//  Created by duanhongjin on 16/9/9.
//  Copyright © 2016年 duanhongjin. All rights reserved.
//

#import "ADPublicReposViewController.h"

@interface ADPublicReposViewController ()

@end

@implementation ADPublicReposViewController

+ (ADViewController *)viewController {
    ADViewController *vc = [[ADPublicReposViewController alloc]initWithNibName:@"ADPublicReposViewController" bundle:nil];
    
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Public Repos";
}

@end
