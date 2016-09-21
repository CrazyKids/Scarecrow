//
//  ADReposSettingsViewController.m
//  Scarecrow
//
//  Created by duanhongjin on 16/9/20.
//  Copyright © 2016年 duanhongjin. All rights reserved.
//

#import "ADReposSettingsViewController.h"
#import "ADReposSettingsViewModel.h"
#import "ADReposOwnerTableViewCell.h"

@interface ADReposSettingsViewController ()

@property (strong, nonatomic, readonly) ADReposSettingsViewModel *viewModel;

@end

@implementation ADReposSettingsViewController

@dynamic viewModel;

+ (ADViewController *)viewController {
    return [[ADReposSettingsViewController alloc]initWithNibName:@"ADReposSettingsViewController" bundle:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Settings";
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ADReposOwnerTableViewCell" bundle:nil] forCellReuseIdentifier:@"ownerCell"];
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    ADReposSettingData data = [self.viewModel.dataSourceArray[section][row] integerValue];
    switch (data) {
        case ADReposSettingDataOwner: {
            ADReposOwnerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ownerCell" forIndexPath:indexPath];
            [cell bindViewModel:self.viewModel];
            
            return cell;
        }
        case ADReposSettingDataQRCode:
            break;
        default:
            break;
    }
    
    return [super tableView:tableView cellForRowAtIndexPath:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    ADReposSettingData data = [self.viewModel.dataSourceArray[section][row] integerValue];
    switch (data) {
        case ADReposSettingDataOwner:
            return 88;
        case ADReposSettingDataQRCode:
            break;
        default:
            break;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 7.5f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 7.5f;
}


@end
