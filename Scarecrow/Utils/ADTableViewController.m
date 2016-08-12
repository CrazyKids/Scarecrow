//
//  ADTableViewController.m
//  Scarecrow
//
//  Created by duanhongjin on 16/7/24.
//  Copyright © 2016年 duanhongjin. All rights reserved.
//

#import "ADTableViewController.h"
#import "ADTableViewModel.h"

@interface ADTableViewController ()

@property (strong, nonatomic, readonly) ADTableViewModel *viewModel;

@end

@implementation ADTableViewController

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
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"emptyCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"emptyCell"];
    }
    
    return cell;
}

@end
