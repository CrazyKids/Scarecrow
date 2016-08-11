//
//  ADSubscribeViewController.m
//  Scarecrow
//
//  Created by duanhongjin on 16/7/24.
//  Copyright © 2016年 duanhongjin. All rights reserved.
//

#import "ADSubscribeViewController.h"
#import "ADSubscribeViewModel.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "ADSubscribeItemViewModel.h"
#import "ADSubscribeTableViewCell.h"

@interface ADSubscribeViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic, readonly) ADSubscribeViewModel *viewModel;


@end

@implementation ADSubscribeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    
    @weakify(self);    
    RAC(self.viewModel, titleViewType) = [self.viewModel.fetchRemoteDataCommamd.executing map:^id(NSNumber *excuting) {
        return excuting.boolValue ? @(ADTitleViewTypeLoading) : @(ADTitleViewTypeDefault);
    }];
    
    [[[RACObserve(self.viewModel, eventArray)filter:^BOOL(NSArray *eventArray) {
        return eventArray.count > 0;
    }]deliverOn:[RACScheduler scheduler]]subscribeNext:^(NSArray *eventArray) {
        @strongify(self);
        if (!self.viewModel.dataSourceArray) {
            self.viewModel.dataSourceArray = @[[self viewModelWithEvents:eventArray]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        } else {
            NSMutableArray *viewModels = [[NSMutableArray alloc] init];
            
            [viewModels addObjectsFromArray:[self viewModelWithEvents:eventArray]];
            [viewModels addObjectsFromArray:self.viewModel.dataSourceArray.firstObject];
            
            self.viewModel.dataSourceArray = @[viewModels.copy];
            
            NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
            
            [eventArray enumerateObjectsUsingBlock:^(OCTEvent *event, NSUInteger idx, BOOL *stop) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:idx inSection:0];
                [indexPaths addObject:indexPath];
            }];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView beginUpdates];
                [self.tableView insertRowsAtIndexPaths:indexPaths.copy withRowAnimation:UITableViewRowAnimationFade];
                [self.tableView endUpdates];
            });
        }
    }];
    
    [[[[NSNotificationCenter defaultCenter]rac_addObserverForName:UIApplicationWillEnterForegroundNotification object:nil]takeUntil:self.rac_willDeallocSignal]subscribeNext:^(id x) {
        @strongify(self);
        [self.viewModel.fetchRemoteDataCommamd execute:nil];
    }];
}

- (NSArray *)viewModelWithEvents:(NSArray *)eventArray {
    return [eventArray.rac_sequence map:^id(OCTEvent *event) {
        ADSubscribeItemViewModel *viewModel = [[ADSubscribeItemViewModel alloc]initWithEvent:event];
        return viewModel;
    }].array;
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
    ADSubscribeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"subscribeCell"];
    
    ADSubscribeItemViewModel *viewModel = self.viewModel.dataSourceArray[indexPath.section][indexPath.row];
    [cell bindViewModel:viewModel];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    ADSubscribeItemViewModel *viewModel = self.viewModel.dataSourceArray[indexPath.section][indexPath.row];
    return viewModel.height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

@end
