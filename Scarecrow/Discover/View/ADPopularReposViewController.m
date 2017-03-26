//
//  ADPopularReposViewController.m
//  Scarecrow
//
//  Created by duanhongjin on 2017/3/25.
//  Copyright © 2017年 duanhongjin. All rights reserved.
//

#import "ADPopularReposViewController.h"
#import "UIImage+Scarecrow.h"
#import "ADPopularReposViewModel.h"

@interface ADPopularReposViewController ()

@property (strong, nonatomic, readonly) ADPopularReposViewModel *viewModel;

@end

@implementation ADPopularReposViewController

@dynamic viewModel;

+ (ADViewController *)viewController {
    return [[ADPopularReposViewController alloc]initWithNibName:@"ADPopularReposViewController" bundle:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImage *rightBarImage = [UIImage ad_highlightImageWithIdentifier:@"Gear" size:CGSizeMake(22, 22)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:rightBarImage style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.rightBarButtonItem.rac_command = self.viewModel.rightBarButtonCommand;
}

@end
