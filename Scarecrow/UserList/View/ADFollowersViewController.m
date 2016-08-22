//
//  ADFollowersViewController.m
//  Scarecrow
//
//  Created by duanhongjin on 16/8/23.
//  Copyright © 2016年 duanhongjin. All rights reserved.
//

#import "ADFollowersViewController.h"

@interface ADFollowersViewController ()

@end

@implementation ADFollowersViewController

+ (__kindof ADViewController *)viewController {
    ADViewController *vc = [[ADFollowersViewController alloc]initWithNibName:@"ADFollowersViewController" bundle:nil];
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Followers";
}

@end
