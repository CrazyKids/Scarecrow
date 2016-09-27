//
//  ADUserInfoViewController.m
//  Scarecrow
//
//  Created by duanhongjin on 8/17/16.
//  Copyright © 2016 duanhongjin. All rights reserved.
//

#import "ADUserInfoViewController.h"
#import "ADUserInfoViewModel.h"
#import "UIColor+Scarecrow.h"
#import "UIImage+Octions.h"

@interface ADUserInfoViewController ()

@property (strong, nonatomic, readonly) ADUserInfoViewModel *viewModel;

@end

@implementation ADUserInfoViewController

@dynamic viewModel;

+ (ADViewController *)viewController {
    ADUserInfoViewController *vc = [[ADUserInfoViewController alloc]initWithNibName:@"ADUserInfoViewController" bundle:nil];
    
    return vc;
}

@end
