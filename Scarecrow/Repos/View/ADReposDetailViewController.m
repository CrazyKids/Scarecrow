//
//  ADReposDetailViewController.m
//  Scarecrow
//
//  Created by duanhongjin on 16/9/11.
//  Copyright © 2016年 duanhongjin. All rights reserved.
//

#import "ADReposDetailViewController.h"
#import "ADReposDetailViewModel.h"
#import "ADReposStatisticsTableViewCell.h"
#import "ADReposViewCodeTableViewCell.h"
#import "ADReposReadmeTableViewCell.h"
#import "UIImage+Octions.h"
#import "OCTRef+Scarecrow.h"

@interface ADReposDetailViewController ()

@property (strong, nonatomic, readonly) ADReposDetailViewModel *viewModel;

@end

@implementation ADReposDetailViewController

@dynamic viewModel;

+ (ADViewController *)viewController {
    return [[ADReposDetailViewController alloc]initWithNibName:@"ADReposDetailViewController" bundle:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ADReposStatisticsTableViewCell" bundle:nil] forCellReuseIdentifier:@"satisticsCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"ADReposViewCodeTableViewCell" bundle:nil] forCellReuseIdentifier:@"viewCodeCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"ADReposReadmeTableViewCell" bundle:nil] forCellReuseIdentifier:@"readmeCell"];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.allowsSelection = NO;
    self.tableView.estimatedRowHeight = 44;
}

- (void)bindViewModel {
    [super bindViewModel];
    
    @weakify(self);
    [self.viewModel.changeBranchCommand.executing subscribeNext:^(NSNumber *executing) {
        @strongify(self);
        if (executing.boolValue) {
            [MBProgressHUD showHUDAddedTo:self.view animated:YES].label.text = @"Loading...";
        } else {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }
    }];
    
    [RACObserve(self.viewModel, repos) subscribeNext:^(id x) {
        @strongify(self);
        [self.tableView reloadData];
    }];
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    ADReposDetailData data = [self.viewModel.dataSourceArray[section][row] integerValue];
    switch (data) {
        case ADReposDetailDataDesc: {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
            cell.textLabel.font = [UIFont systemFontOfSize:15];
            cell.textLabel.numberOfLines = 0;
            cell.textLabel.text = self.viewModel.repos.repoDescription;
            
            return cell;
        }
        case ADReposDetailDataStatistics: {
            ADReposStatisticsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"satisticsCell" forIndexPath:indexPath];
            
            cell.forkCountLabel.text = [NSString stringWithFormat:@"%ld", self.viewModel.repos.forksCount];
            cell.starCountLabel.text = [NSString stringWithFormat:@"%ld", self.viewModel.repos.stargazersCount];
            
            [[RACObserve(self.viewModel.repos, stargazersCount) deliverOnMainThread]subscribeNext:^(NSNumber *stargazersCount) {
                cell.starCountLabel.text = stargazersCount.stringValue;
            }];
            
            return cell;
        }
        case ADReposDetailDataViewCode: {
            ADReposViewCodeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"viewCodeCell" forIndexPath:indexPath];
            
            [RACObserve(self.viewModel, reference)subscribeNext:^(OCTRef *reference) {
                cell.branchIcon.image = [UIImage ad_normalImageWithIdentifier:reference.ad_octiconIdentifier size:CGSizeMake(24, 24)];
                NSString *title = [reference.name componentsSeparatedByString:@"/"].lastObject;
                [cell.branchButton setTitle:title forState:UIControlStateNormal];
            }];
            
            cell.timeLabel.text = self.viewModel.dateUpdated;
            
            UIImage *image = [UIImage ad_highlightImageWithIdentifier:@"FileDirectory" size:CGSizeMake(22, 22)];
            [cell.viewCodeButton setImage:image forState:UIControlStateNormal];
        }
        case ADReposDetailDataReadme:
            break;
        default:
            break;
    }
    
    return [super tableView:tableView cellForRowAtIndexPath:indexPath];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    ADReposDetailData data = [self.viewModel.dataSourceArray[section][row] integerValue];
    switch (data) {
        case ADReposDetailDataDesc:
            return UITableViewAutomaticDimension;
        case ADReposDetailDataStatistics:
            return 58;
        case ADReposDetailDataViewCode:
            return 114;
        case ADReposDetailDataReadme:
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
