//
//  ADUserListViewController.m
//  Scarecrow
//
//  Created by duanhongjin on 8/23/16.
//  Copyright © 2016 duanhongjin. All rights reserved.
//

#import "ADUserListViewController.h"
#import "ADUserListViewModel.h"
#import "ADUserListItemTableViewCell.h"
#import "ADUserListItemViewModel.h"

@interface ADUserListViewController ()

@property (strong, nonatomic, readonly) ADUserListViewModel *viewModel;

@end

@implementation ADUserListViewController

@dynamic viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ADUserListItemTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ADUserListItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    ADUserListItemViewModel *viewModel = self.viewModel.dataSourceArray[indexPath.section][indexPath.row];
    [cell bindViewModel:viewModel];
    
    return cell;
}

@end
