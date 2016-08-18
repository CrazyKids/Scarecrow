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
    
    self.tableView.contentInset = UIEdgeInsetsZero;
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
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    UIColor *bgColor = [UIColor clearColor];
    CGSize size = CGSizeMake(25, 25);
    
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
                cell.imageView.image = [UIImage ad_imageWithIcon:@"Person" backgroundColor:bgColor iconColor:DEFAULT_RGB iconScale:1 size:size];
                cell.textLabel.text = @"name";
                cell.detailTextLabel.text = self.viewModel.user.name;
                break;
            case 1:
                cell.imageView.image = [UIImage ad_imageWithIcon:@"Star" backgroundColor:bgColor iconColor:DEFAULT_RGB iconScale:1 size:size];
                cell.textLabel.text = @"Starred Repos";
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
                break;
            case 1:
                cell.imageView.image = [UIImage ad_imageWithIcon:@"Location" backgroundColor:bgColor iconColor:DEFAULT_RGB iconScale:1 size:size];
                cell.textLabel.text = self.viewModel.location;
                break;
            case 2:
                cell.imageView.image = [UIImage ad_imageWithIcon:@"Mail" backgroundColor:bgColor iconColor:DEFAULT_RGB iconScale:1 size:size];
                cell.textLabel.text = self.viewModel.email;
                break;
            case 3:
                cell.imageView.image = [UIImage ad_imageWithIcon:@"Link" backgroundColor:bgColor iconColor:DEFAULT_RGB iconScale:1 size:size];
                cell.textLabel.text = self.viewModel.blog;
                break;
            default:
                cell.imageView.image = nil;
                cell.textLabel.text = nil;
                break;
        }
    }
    return cell;
}

@end
