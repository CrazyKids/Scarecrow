//
//  ADFollowingViewController.m
//  Scarecrow
//
//  Created by duanhongjin on 8/20/16.
//  Copyright © 2016 duanhongjin. All rights reserved.
//

#import "ADFollowingViewController.h"
#import "UIStoryboard+ViewModel.h"

@interface ADFollowingViewController ()

@end

@implementation ADFollowingViewController

+ (__kindof ADViewController *)viewController {
    ADViewController *vc = [[UIStoryboard storyboardWithName:@"Following" bundle:nil]instantiateViewControllerWithIdentifier:@"following"];
    
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Following";
}

@end
