//
//  ADDiscoverViewController.m
//  Scarecrow
//
//  Created by duanhongjin on 17/03/2017.
//  Copyright © 2017 duanhongjin. All rights reserved.
//

#import "ADDiscoverViewController.h"
#import "ADDiscoverItemViewModel.h"
#import "ADDiscoverViewModel.h"

@interface ADDiscoverViewController ()

@property (strong, nonatomic) ADDiscoverItemViewModel *viewModel;

@end

@implementation ADDiscoverViewController

@dynamic viewModel;

+ (ADViewController *)viewController {
    ADViewController *vc = [[UIStoryboard storyboardWithName:@"Discover" bundle:nil]instantiateViewControllerWithIdentifier:@"Discover"];
    
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [UITableViewCell new];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

@end
