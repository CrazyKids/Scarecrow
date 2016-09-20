//
//  ADSubscribeViewController.m
//  Scarecrow
//
//  Created by duanhongjin on 16/7/24.
//  Copyright © 2016年 duanhongjin. All rights reserved.
//

#import "ADSubscribeViewController.h"
#import "ADSubscribeViewModel.h"
#import "ADSubscribeItemViewModel.h"
#import "ADSubscribeTableViewCell.h"
#import <ZRPopoverView/ZRPopoverView.h>
#import "ADQRCodeScanView.h"

@interface ADSubscribeViewController ()<ZRPopoverViewDelegate>

@property (strong, nonatomic, readonly) ADSubscribeViewModel *viewModel;

@end

@implementation ADSubscribeViewController

@dynamic viewModel;

+ (ADViewController *)viewController {
    ADViewController *vc = [[UIStoryboard storyboardWithName:@"Subscribe" bundle:nil]instantiateViewControllerWithIdentifier:@"subscribe"];
    
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(rightBarClick)];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ADSubscribeTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
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

- (void)rightBarClick
{
    NSArray *menus = @[
                       @{ kZRPopoverViewTitle: @"扫一扫", kZRPopoverViewIcon : @"QR_snap" }
                       ];
    ZRPopoverView *popover = [[ZRPopoverView alloc] initWithStyle:ZRPopoverViewStyleLightContent menus:menus position:ZRPopoverViewPositionRightOfTop];
    popover.delegate = self;
    [popover showWithController:self];
}

#pragma mark - ZRPopoverViewDelegate
- (void)popoverView:(ZRPopoverView *)popoverView didClick:(int)index
{
    if (index == 0) {
        [[[ADQRCodeScanView alloc] init] openQRCodeScan:self];
    }
}

- (NSArray *)viewModelWithEvents:(NSArray *)eventArray {
    @weakify(self);
    return [eventArray.rac_sequence map:^id(OCTEvent *event) {
        @strongify(self);
        
        ADSubscribeItemViewModel *viewModel = [[ADSubscribeItemViewModel alloc]initWithEvent:event];
        viewModel.didClickLinkCommand = self.viewModel.didClickLinkCommand;
        return viewModel;
    }].array;
}

- (void)reloadData {
    
}

#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    ADSubscribeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    ADSubscribeItemViewModel *viewModel = self.viewModel.dataSourceArray[indexPath.section][indexPath.row];
    [cell bindViewModel:viewModel];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    ADSubscribeItemViewModel *viewModel = self.viewModel.dataSourceArray[indexPath.section][indexPath.row];
    return viewModel.height;
}

@end
