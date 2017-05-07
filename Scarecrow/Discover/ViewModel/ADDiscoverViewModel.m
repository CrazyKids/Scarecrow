//
//  ADDiscoverViewModel.m
//  Scarecrow
//
//  Created by duanhongjin on 8/2/16.
//  Copyright © 2016 duanhongjin. All rights reserved.
//

#import "ADDiscoverViewModel.h"
#import "ADDiscoverItemViewModel.h"
#import "ADTrendingViewModel.h"
#import "ADPopularUsersViewModel.h"
#import "ADPopularReposViewModel.h"
#import "ADShowCasesViewModel.h"
#import "ADSearchViewModel.h"
#import "ADBrowseViewModel.h"
#import "UIImage+Scarecrow.h"

@interface ADDiscoverViewModel ()

@end

@implementation ADDiscoverViewModel

- (void)initialize {
    [super initialize];
    
    self.bShouldFetchData = NO;
    self.bShouldPullToRefresh = NO;
    
    [self setupData];
    
    @weakify(self);
    self.didSelectCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(NSIndexPath *indexPath) {
        @strongify(self);
        NSArray *sectionData = self.dataSourceArray[indexPath.section];
        ADDiscoverItemViewModel *viewModel = sectionData[indexPath.row];
        
        return [viewModel.itemCommand execute:nil];
    }];
}

- (void)setupData {
    NSMutableArray *sectionData = [NSMutableArray new];
    
    // 1.Trending
    [sectionData addObject:@[self.trendingViewModel]];
    
    // 2. Popular users and repositories
    [sectionData addObject:@[self.popularUsersViewModel, self.popularRepositoriesViewModel]];

    // 3. Show Cases
    [sectionData addObject:@[self.showCasesViewModel]];

    // 4. Search users and repositories
//    [sectionData addObject:@[self.searchUsersViewModel, self.searchReposViewModel]];
//
//    // 5. Browse
//    [sectionData addObject:@[self.browseViewModel]];
    
    self.dataSourceArray = sectionData;
}

- (ADDiscoverItemViewModel *)trendingViewModel {
    UIImage *itemIcon = [UIImage imageNamed:@"icon_qrcode"];
    
    @weakify(self);
    RACCommand *itemCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        
        ADTrendingViewModel *viewModel = [[ADTrendingViewModel alloc]initWithParam:nil];
        [self pushViewControllerWithViewModel:viewModel];
        
        return [RACSignal empty];
    }];
    
    NSDictionary *param = @{@"itemName" : @"Trending",
                            @"itemIcon" : itemIcon,
                            @"itemCommand": itemCommand};
    
    return [[ADDiscoverItemViewModel alloc]initWithParam:param];
}

- (ADDiscoverItemViewModel *)popularUsersViewModel {
    UIImage *itemIcon = [UIImage imageNamed:@"icon_qrcode"];
    
    @weakify(self);
    RACCommand *itemCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        
        ADPopularUsersViewModel *viewModel = [[ADPopularUsersViewModel alloc]initWithParam:nil];
        [self pushViewControllerWithViewModel:viewModel];
        
        return [RACSignal empty];
    }];
    
    NSDictionary *param = @{@"itemName" : @"Popular Users",
                            @"itemIcon" : itemIcon,
                            @"itemCommand": itemCommand};
    
    return [[ADDiscoverItemViewModel alloc]initWithParam:param];
}

- (ADDiscoverItemViewModel *)popularRepositoriesViewModel {
    UIImage *itemIcon = [UIImage imageNamed:@"icon_qrcode"];
    
    @weakify(self);
    RACCommand *itemCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        
        ADPopularReposViewModel *viewModel = [[ADPopularReposViewModel alloc]initWithParam:nil];
        [self pushViewControllerWithViewModel:viewModel];
        
        return [RACSignal empty];
    }];
    
    NSDictionary *param = @{@"itemName" : @"Popular Repositories",
                            @"itemIcon" : itemIcon,
                            @"itemCommand": itemCommand};
    
    return [[ADDiscoverItemViewModel alloc]initWithParam:param];
}

- (ADDiscoverItemViewModel *)showCasesViewModel {
    UIImage *itemIcon = [UIImage imageNamed:@"icon_qrcode"];
    
    @weakify(self);
    RACCommand *itemCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        
        ADShowCasesViewModel *viewModel = [[ADShowCasesViewModel alloc]initWithParam:nil];
        [self pushViewControllerWithViewModel:viewModel];
        
        return [RACSignal empty];
    }];
    
    NSDictionary *param = @{@"itemName" : @"ShowCases",
                            @"itemIcon" : itemIcon,
                            @"itemCommand": itemCommand};
    
    return [[ADDiscoverItemViewModel alloc]initWithParam:param];
}

- (ADDiscoverItemViewModel *)searchUsersViewModel {
    UIImage *itemIcon = [UIImage imageNamed:@"icon_qrcode"];
    
    @weakify(self);
    RACCommand *itemCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        
        ADSearchViewModel *viewModel = [[ADSearchViewModel alloc]initWithParam:@{@"searchType":@"users"}];
        viewModel.capture = [UIImage ad_screenCapture];
        [self presentViewControllerWithViewModel:viewModel animated:NO];
        
        return [RACSignal empty];
    }];
    
    NSDictionary *param = @{@"itemName" : @"Search Users",
                            @"itemIcon" : itemIcon,
                            @"itemCommand": itemCommand};
    
    return [[ADDiscoverItemViewModel alloc]initWithParam:param];
}

- (ADDiscoverItemViewModel *)searchReposViewModel {
    UIImage *itemIcon = [UIImage imageNamed:@"icon_qrcode"];
    
    @weakify(self);
    RACCommand *itemCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        
        ADSearchViewModel *viewModel = [[ADSearchViewModel alloc]initWithParam:@{@"searchType":@"repositories"}];
        viewModel.capture = [UIImage ad_screenCapture];
        [self presentViewControllerWithViewModel:viewModel animated:NO];
        
        return [RACSignal empty];
    }];
    
    NSDictionary *param = @{@"itemName" : @"Search Repositories",
                            @"itemIcon" : itemIcon,
                            @"itemCommand": itemCommand};
    
    return [[ADDiscoverItemViewModel alloc]initWithParam:param];
}

- (ADDiscoverItemViewModel *)browseViewModel {
    UIImage *itemIcon = [UIImage imageNamed:@"icon_qrcode"];
    
    @weakify(self);
    RACCommand *itemCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        
        ADBrowseViewModel *viewModel = [[ADBrowseViewModel alloc]initWithParam:nil];
        [self pushViewControllerWithViewModel:viewModel];
        
        return [RACSignal empty];
    }];
    
    NSDictionary *param = @{@"itemName" : @"Browse",
                            @"itemIcon" : itemIcon,
                            @"itemCommand": itemCommand};
    
    return [[ADDiscoverItemViewModel alloc]initWithParam:param];
}

@end
