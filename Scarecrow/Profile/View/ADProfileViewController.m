//
//  ADProfileViewController.m
//  Scarecrow
//
//  Created by duanhongjin on 8/15/16.
//  Copyright © 2016 duanhongjin. All rights reserved.
//

#import "ADProfileViewController.h"
#import "ADProfileViewModel.h"
#import "ADAvatarHeaderViewModel.h"
#import "ADAvatarHeaderView.h"
#import <SDWebImage/SDWebImagePrefetcher.h>
#import "UIImage+Octions.h"
#import "UIColor+Scarecrow.h"

@interface ADProfileViewController ()

@property (strong, nonatomic) ADProfileViewModel *viewModel;
@property (strong, nonatomic) ADAvatarHeaderView *headerView;

@end

@implementation ADProfileViewController

@dynamic viewModel;

+ (ADViewController *)viewControllerWithViewModel:(ADViewModel *)viewModel {
    ADViewController *vc = [[UIStoryboard storyboardWithName:@"Profile" bundle:nil]instantiateViewControllerWithIdentifier:@"profile"];
    viewModel.ownerVC = vc;
    [vc setValue:viewModel forKey:@"viewModel"];
    
    return vc;
}

- (void)initializeWithViewMode:(ADViewModel *)viewModel {
    [super initializeWithViewMode:viewModel];
    
    if (self.viewModel.avatarHeaderViewModel.user.avatarURL) {
        SDWebImagePrefetcher *prefetcher = [SDWebImagePrefetcher sharedImagePrefetcher];
        prefetcher.options = SDWebImageRefreshCached;
        [prefetcher prefetchURLs:@[self.viewModel.avatarHeaderViewModel.user.avatarURL ?: [NSNull null]]];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.contentInset = UIEdgeInsetsMake(-64, 0, 0, 0);
    
    self.headerView = [[NSBundle mainBundle]loadNibNamed:@"ADAvatarHeanderView" owner:nil options:nil].firstObject;
    [self.headerView bindViewModel:self.viewModel.avatarHeaderViewModel];
    
    self.headerView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
    
    self.tableView.tableHeaderView = self.headerView;
    
    @weakify(self);
    [RACObserve(self.viewModel, user)subscribeNext:^(id x) {
        @strongify(self);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 4;
    }
    
    return 1;
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
    } else if (indexPath.section == 1) {
        cell.imageView.image = [UIImage ad_imageWithIcon:@"Gear" backgroundColor:bgColor iconColor:DEFAULT_RGB iconScale:1 size:size];
        cell.textLabel.text = @"Setting";
    }
    return cell;
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

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGPoint contentOffset = scrollView.contentOffset;
    self.viewModel.avatarHeaderViewModel.contentOffset = contentOffset;
}

@end
