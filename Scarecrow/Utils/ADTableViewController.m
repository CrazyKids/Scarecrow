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
}

@end
