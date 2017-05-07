//
//  ADSearchViewController.m
//  Scarecrow
//
//  Created by duanhongjin on 2017/5/1.
//  Copyright © 2017年 duanhongjin. All rights reserved.
//

#import "ADSearchViewController.h"
#import "ADSearchViewModel.h"
#import "ADSearchBar.h"
#import "UIColor+Scarecrow.h"

@interface ADSearchViewController () <UISearchControllerDelegate>

@property (strong, nonatomic) ADSearchViewModel *viewModel;
@property (strong, nonatomic) ADSearchBar *searchBar;
@property (strong, nonatomic) UIView *searchBarBackground;
@property (strong, nonatomic) UISearchController *searchController;

@end

@implementation ADSearchViewController

@dynamic viewModel;

+ (ADViewController *)viewController {
    return [[ADSearchViewController alloc]initWithNibName:@"ADSearchViewController" bundle:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.viewModel.capture) {
        UIImageView *captureView = [[UIImageView alloc]initWithImage:self.viewModel.capture];
        [self.view addSubview:captureView];
    }
    
//    self.searchBar = [[ADSearchBar alloc]initWithFrame:CGRectMake(0, 0, LAYOUT_DEFAULT_WIDTH, 44)];
//    
//    self.searchBarBackground = [[UIView alloc]initWithFrame:CGRectMake(0, 0, LAYOUT_DEFAULT_WIDTH, 44)];
//    self.searchBarBackground.backgroundColor = DEFAULT_RGB;
//    [self.searchBarBackground addSubview:self.searchBar];
//    self.navigationItem.titleView = self.searchBarBackground;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

#pragma mark - UISearchControllerDelegate

@end
