//
//  ADSettingsViewController.m
//  Scarecrow
//
//  Created by duanhongjin on 8/19/16.
//  Copyright © 2016 duanhongjin. All rights reserved.
//

#import "ADSettingsViewController.h"
#import "ADSetttingsViewModel.h"
#import "UIColor+Scarecrow.h"

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
    
    UIView *tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, 50)];
    tableFooterView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    tableFooterView.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = tableFooterView;
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 15, tableFooterView.frame.size.width, 20)];
    label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:18];
    label.textColor = DEFAULT_RGB;
    label.text = [NSString stringWithFormat:@"Version: %@", AD_APP_VERSION];
    label.textAlignment = NSTextAlignmentCenter;
    [tableFooterView addSubview:label];
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
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCellStyleValue1" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = @"My Account";
        cell.detailTextLabel.text = [ADPlatformManager sharedInstance].client.user.login;
        
        return cell;
    }
    
    if (indexPath.section == 1) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.textColor = [UIColor redColor];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 1) {
        NSString *message = @"Logout will not delete any data. You can login again.";
        @weakify(self);
        [[ZRAlertController defaultAlert]alertShowWithTitle:nil message:message cancelButton:@"Cancel" okayButton:@"OK" okayHandler:^{
            @strongify(self);
            [self.viewModel.logoutCommand execute:nil];
        } cancelHandler:^{
            
        }];
    }
}

@end
