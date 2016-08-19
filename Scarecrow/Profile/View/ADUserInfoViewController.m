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

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 3;
        case 1:
            return 4;
        default:
            break;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    
    cell.accessoryType  = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    
    UIColor *bgColor = [UIColor clearColor];
    CGSize size = CGSizeMake(25, 25);
    
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
                cell.imageView.image = [UIImage ad_imageWithIcon:@"Person" backgroundColor:bgColor iconColor:DEFAULT_RGB iconScale:1 size:size];
                cell.textLabel.text = @"name";
                cell.detailTextLabel.text = self.viewModel.user.name;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                break;
            case 1:
                cell.imageView.image = [UIImage ad_imageWithIcon:@"Star" backgroundColor:bgColor iconColor:DEFAULT_RGB iconScale:1 size:size];
                cell.textLabel.text = @"Starred Repos";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                break;
            case 2:
                cell.imageView.image = [UIImage ad_imageWithIcon:@"Rss" backgroundColor:bgColor iconColor:DEFAULT_RGB iconScale:1 size:size];
                cell.textLabel.text = @"Public Activity";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                break;
            default:
                cell.imageView.image = nil;
                cell.textLabel.text = nil;
                break;
        }
    } else if (indexPath.section == 1) {
        switch (indexPath.row) {
            case 0:
                cell.imageView.image = [UIImage ad_imageWithIcon:@"Organization" backgroundColor:bgColor iconColor:DEFAULT_RGB iconScale:1 size:size];
                cell.textLabel.text = self.viewModel.compay;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                break;
            case 1:
                cell.imageView.image = [UIImage ad_imageWithIcon:@"Location" backgroundColor:bgColor iconColor:DEFAULT_RGB iconScale:1 size:size];
                cell.textLabel.text = self.viewModel.location;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                break;
            case 2:
                cell.imageView.image = [UIImage ad_imageWithIcon:@"Mail" backgroundColor:bgColor iconColor:DEFAULT_RGB iconScale:1 size:size];
                cell.textLabel.text = self.viewModel.email;
                if (self.viewModel.email != kDefaultPlaceHolder) {
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                }
                break;
            case 3:
                cell.imageView.image = [UIImage ad_imageWithIcon:@"Link" backgroundColor:bgColor iconColor:DEFAULT_RGB iconScale:1 size:size];
                cell.textLabel.text = self.viewModel.blog;
                if (self.viewModel.blog != kDefaultPlaceHolder) {
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                }
                break;
            default:
                cell.imageView.image = nil;
                cell.textLabel.text = nil;
                break;
        }
    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        [self.viewModel.didSelectCommand execute:indexPath];
        return;
    }
    
    switch (indexPath.row) {
        case 2:
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"mailto:%@", self.viewModel.email]]];
            break;
        case 3:
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.viewModel.blog]];
            break;
        default:
            break;
    }
}


@end
