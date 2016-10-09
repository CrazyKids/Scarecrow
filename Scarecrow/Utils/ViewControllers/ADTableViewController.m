//
//  ADTableViewController.m
//  Scarecrow
//
//  Created by duanhongjin on 16/7/24.
//  Copyright © 2016年 duanhongjin. All rights reserved.
//

#import "ADTableViewController.h"
#import "ADTableViewModel.h"
#import <EGOTableViewPullRefreshAndLoadMore/EGORefreshTableHeaderView.h>
#import "UIColor+Scarecrow.h"
#import "ADTableViewCellStyleValue1.h"

@interface ADTableViewController () <EGORefreshTableHeaderDelegate, UIScrollViewDelegate>

@property (strong, nonatomic, readonly) ADTableViewModel *viewModel;
@property (strong, nonatomic) EGORefreshTableHeaderView *refreshHeaderView;
@property (assign, nonatomic, getter=isLoading) BOOL loading;

@end

@implementation ADTableViewController

@dynamic viewModel;

- (void)initializeWithViewMode:(ADViewModel *)viewModel {
    [super initializeWithViewMode:viewModel];
    
    if (self.viewModel.bShouldFetchData) {
        @weakify(self);
        [[self rac_signalForSelector:@selector(viewDidLoad)]subscribeNext:^(id x) {
            @strongify(self);
            [self.viewModel.fetchRemoteDataCommamd execute:@(1)];
        }];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = RGB(0xE6E6E7);
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.contentInset = [self contentInsets];
    
    [self.tableView registerClass:[ADTableViewCellStyleValue1 class] forCellReuseIdentifier:@"UITableViewCellStyleValue1"];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    
    if (self.viewModel.bShouldPullToRefresh) {
        CGRect frame = self.tableView.frame;
        frame.origin.x = 0;
        frame.origin.y = -frame.size.height;
        
        self.refreshHeaderView = [[EGORefreshTableHeaderView alloc]initWithFrame:frame];
        self.refreshHeaderView.delegate = self;
        [self.tableView addSubview:self.refreshHeaderView];
    }
    
    if (self.viewModel.showLoading) {
        @weakify(self)
        [self.viewModel.fetchRemoteDataCommamd.executing subscribeNext:^(NSNumber *executing) {
            @strongify(self)
            if (executing.boolValue && self.viewModel.dataSourceArray.count == 0) {
                [MBProgressHUD showHUDAddedTo:self.view animated:YES].label.text = @"Loading...";
            } else {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            }
        }];
    }
}

- (void)bindViewModel {
    [super bindViewModel];
    
    @weakify(self)
    [[[RACObserve(self.viewModel, dataSourceArray) distinctUntilChanged]deliverOnMainThread]subscribeNext:^(id x) {
         @strongify(self)
         [self reloadData];
     }];
}

- (void)reloadData {
    [self.tableView reloadData];
}

- (UIEdgeInsets)contentInsets {
    return UIEdgeInsetsZero;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger count = self.viewModel.dataSourceArray.count;
    return count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count =  [self.viewModel.dataSourceArray[section] count];
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    cell.textLabel.text = @"Empty Cell";
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self.viewModel.didSelectCommand execute:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    CGFloat height = [self tableView:tableView heightForHeaderInSection:section];
    if (height == 0) {
        return nil;
    }
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, height)];
    view.backgroundColor = [UIColor clearColor];
    
    return view;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    CGFloat height = [self tableView:tableView heightForFooterInSection:section];
    if (height == 0) {
        return nil;
    }
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, height)];
    view.backgroundColor = [UIColor clearColor];
    
    return view;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self.refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}

- (NSUInteger)dataCount {
    NSUInteger count = 0;
    
    for (NSArray *array in self.viewModel.dataSourceArray) {
        count += array.count;
    }
    
    return count;
}

- (BOOL)needRefresh {
    return self.viewModel.page * self.viewModel.pageStep <= self.dataCount;
}

#pragma mark - EGORefreshTableHeaderDelegate
- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view {
    self.loading = YES;
    
    int page = self.viewModel.page;
    if (self.needRefresh) {
        page += 1;
    }

    @weakify(self);
    [[[self.viewModel.fetchRemoteDataCommamd execute:@(page)]deliverOnMainThread]subscribeNext:^(NSArray *dataSourceArray) {

    } error:^(NSError *error) {
        @strongify(self);
        self.loading = NO;
        [self.refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
    } completed:^{
        @strongify(self);
        self.loading = NO;
        [self.refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
    }];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view {
    return self.isLoading;
}

@end
