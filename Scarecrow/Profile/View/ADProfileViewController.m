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
#import "ADSetttingsViewModel.h"
#import "OCTUser+Persistence.h"

@interface ADProfileViewController ()

@property (strong, nonatomic) ADProfileViewModel *viewModel;
@property (strong, nonatomic) ADAvatarHeaderView *headerView;

@end

@implementation ADProfileViewController

@dynamic viewModel;

+ (ADViewController *)viewController {
    ADViewController *vc = [[UIStoryboard storyboardWithName:@"Profile" bundle:nil]instantiateViewControllerWithIdentifier:@"profile"];
    
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
    
    self.headerView = [[NSBundle mainBundle]loadNibNamed:@"ADAvatarHeanderView" owner:nil options:nil].firstObject;
    [self.headerView bindViewModel:self.viewModel.avatarHeaderViewModel];
    
    self.headerView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
    
    self.tableView.tableHeaderView = self.headerView;
    
    if ([self.viewModel.user.objectID isEqualToString:[OCTUser ad_currentUser].objectID]) {
        UIImage *image = [UIImage ad_imageWithIcon:@"Gear" backgroundColor:[UIColor clearColor] iconColor:[UIColor whiteColor] iconScale:1 size:CGSizeMake(25, 25)];
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(onSettingButtonClicked:)];
    }

    @weakify(self);
    [RACObserve(self.viewModel, user)subscribeNext:^(id x) {
        @strongify(self);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }];
}

- (UIEdgeInsets)contentInsets {
    return UIEdgeInsetsMake(-64, 0, 0, 0);
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCellStyleValue1" forIndexPath:indexPath];
    
    cell.accessoryType  = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    
    UIColor *bgColor = [UIColor clearColor];
    CGSize size = CGSizeMake(25, 25);
    
    ADUserInfoDataType type = [self.viewModel.dataSourceArray[indexPath.section][indexPath.row] integerValue];
    switch (type) {
        case ADUserInfoDataTypeOrganization:
            cell.imageView.image = [UIImage ad_imageWithIcon:@"Organization" backgroundColor:bgColor iconColor:DEFAULT_RGB iconScale:1 size:size];
            cell.textLabel.text = self.viewModel.compay;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            break;
        case ADUserInfoDataTypeLocation:
            cell.imageView.image = [UIImage ad_imageWithIcon:@"Location" backgroundColor:bgColor iconColor:DEFAULT_RGB iconScale:1 size:size];
            cell.textLabel.text = self.viewModel.location;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            break;
        case ADUserInfoDataTypeMail:
            cell.imageView.image = [UIImage ad_imageWithIcon:@"Mail" backgroundColor:bgColor iconColor:DEFAULT_RGB iconScale:1 size:size];
            cell.textLabel.text = self.viewModel.email;
            if (self.viewModel.email != kDefaultPlaceHolder) {
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            break;
        case ADUserInfoDataTypeLink:
            cell.imageView.image = [UIImage ad_imageWithIcon:@"Link" backgroundColor:bgColor iconColor:DEFAULT_RGB iconScale:1 size:size];
            cell.textLabel.text = self.viewModel.blog;
            if (self.viewModel.blog != kDefaultPlaceHolder) {
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            break;
        case ADUserInfoDataTypeName:
            cell.imageView.image = [UIImage ad_imageWithIcon:@"Person" backgroundColor:bgColor iconColor:DEFAULT_RGB iconScale:1 size:size];
            cell.textLabel.text = @"name";
            cell.detailTextLabel.text = self.viewModel.user.name;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            break;
        case ADUserInfoDataTypeStarred:
            cell.imageView.image = [UIImage ad_imageWithIcon:@"Star" backgroundColor:bgColor iconColor:DEFAULT_RGB iconScale:1 size:size];
            cell.textLabel.text = @"Starred Repos";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
        case ADUserInfoDataTypeActivity:
            cell.imageView.image = [UIImage ad_imageWithIcon:@"Rss" backgroundColor:bgColor iconColor:DEFAULT_RGB iconScale:1 size:size];
            cell.textLabel.text = @"Public Activity";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
        case ADUserInfoDataTypeGenerateQRCode:
            cell.imageView.image = [UIImage imageNamed:@"icon_qrcode"];
            cell.textLabel.text = @"My QR Code";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
        default:
            cell.imageView.image = nil;
            cell.textLabel.text = nil;
            break;
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

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGPoint contentOffset = scrollView.contentOffset;
    self.viewModel.avatarHeaderViewModel.contentOffset = contentOffset;
}

- (void)onSettingButtonClicked:(id)sender {
    ADSetttingsViewModel *viewModel = [ADSetttingsViewModel new];
    
    [self.viewModel pushViewControllerWithViewModel:viewModel];
}

@end
