//
//  ADSettingsViewController.m
//  Scarecrow
//
//  Created by duanhongjin on 8/19/16.
//  Copyright © 2016 duanhongjin. All rights reserved.
//

#import "ADSettingsViewController.h"
#import "ADSetttingsViewModel.h"
#import <ZRAlertController/ZRAlertController.h>

@interface ADSettingsViewController ()

@property (strong, nonatomic, readonly) ADSetttingsViewModel *viewModel;

@end

@implementation ADSettingsViewController

@dynamic viewModel;

+ (ADViewController *)viewController {
    ADSettingsViewController *vc = [[ADSettingsViewController alloc]initWithNibName:@"ADSettingsViewController" bundle:nil];
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell00"];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell00"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.textLabel.text = @"My Account";
        cell.detailTextLabel.text = [ADPlatformManager sharedInstance].client.user.login;
        
        return cell;
    }
    
    if (indexPath.section == 1) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell10"];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell10"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.textColor = [UIColor redColor];
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
        }
        cell.textLabel.text = @"Logout";
        
        return cell;
    }
    
    return [super tableView:tableView cellForRowAtIndexPath:indexPath];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section == 0 ? 20 : 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return section == tableView.numberOfSections - 1 ? 20 : 10;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    CGFloat height = [self tableView:tableView heightForHeaderInSection:section];
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, height)];
    view.backgroundColor = [UIColor clearColor];
    
    return view;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    CGFloat height = [self tableView:tableView heightForFooterInSection:section];
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, height)];
    view.backgroundColor = [UIColor clearColor];
    
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 1) {
        NSString *message = @"Logout will not delete any data. You can login again.";
        @weakify(self);
        [[ZRAlertController defaultAlert]alertShow:self title:@"" message:message cancelButton:@"Cancel" okayButton:@"OK" okayHandler:^{
            @strongify(self);
            [self.viewModel.logoutCommand execute:nil];
        } cancelHandler:nil];
    }
}

@end
