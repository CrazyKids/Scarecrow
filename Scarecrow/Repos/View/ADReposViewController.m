//
//  ADReposViewController.m
//  Scarecrow
//
//  Created by duanhongjin on 16/8/30.
//  Copyright © 2016年 duanhongjin. All rights reserved.
//

#import "ADReposViewController.h"
#import "ADReposViewModel.h"
#import "ADReposItemViewModel.h"
#import "ADReposTableViewCell.h"

@interface ADReposViewController ()

@property (strong, nonatomic, readonly) ADReposViewModel *viewModel;

@end

@implementation ADReposViewController

+ (ADViewController *)viewController {
    ADViewController *vc = [[UIStoryboard storyboardWithName:@"Repos" bundle:nil]instantiateViewControllerWithIdentifier:@"repos"];
    
    return vc;
}

@dynamic viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Repos";
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ADReposTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ADReposItemViewModel *viewModel = self.viewModel.dataSourceArray[indexPath.section][indexPath.row];
    
    ADReposTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    [cell bindViewModel:viewModel];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    ADReposItemViewModel *viewModel = self.viewModel.dataSourceArray[indexPath.section][indexPath.row];
    return viewModel.height;
}

@end
