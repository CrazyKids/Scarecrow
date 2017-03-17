//
//  ADDiscoverViewModel.m
//  Scarecrow
//
//  Created by duanhongjin on 8/2/16.
//  Copyright © 2016 duanhongjin. All rights reserved.
//

#import "ADDiscoverViewModel.h"
#import "ADDiscoverItemViewModel.h"

@interface ADDiscoverViewModel ()

@end

@implementation ADDiscoverViewModel

- (void)initialize {
    [super initialize];
    
    self.bShouldFetchData = NO;
    self.bShouldPullToRefresh = NO;
    
    [self setupData];
}

- (void)setupData {
    NSMutableArray *sectionData = [NSMutableArray new];
    
    // 1.Trending
    [sectionData addObject:@[self.trendingViewModel]];
    
    // 2. Popular users and repositories
    [sectionData addObject:@[self.popularUsersViewModel, self.popularRepositoriesViewModel]];
    
    // 3. Show Cases
    [sectionData addObject:@[self.showCasesViewModel]];
    
    // 4. Search
    [sectionData addObject:@[self.searchViewModel]];
    
    // 5. Browse
    [sectionData addObject:@[self.browseViewModel]];
    
    self.dataSourceArray = sectionData;
}

- (ADDiscoverItemViewModel *)trendingViewModel {
    UIImage *itemIcon = [UIImage new];
    RACCommand *itemCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        return [RACSignal empty];
    }];
    
    NSDictionary *param = @{@"itemName" : @"Trending",
                            @"itemIcon" : itemIcon,
                            @"itemCommand": itemCommand};
    
    return [[ADDiscoverItemViewModel alloc]initWithParam:param];
}

- (ADDiscoverItemViewModel *)popularUsersViewModel {
    UIImage *itemIcon = [UIImage new];
    RACCommand *itemCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        return [RACSignal empty];
    }];
    
    NSDictionary *param = @{@"itemName" : @"Popular Users",
                            @"itemIcon" : itemIcon,
                            @"itemCommand": itemCommand};
    
    return [[ADDiscoverItemViewModel alloc]initWithParam:param];
}

- (ADDiscoverItemViewModel *)popularRepositoriesViewModel {
    UIImage *itemIcon = [UIImage new];
    RACCommand *itemCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        return [RACSignal empty];
    }];
    
    NSDictionary *param = @{@"itemName" : @"Popular Repositories",
                            @"itemIcon" : itemIcon,
                            @"itemCommand": itemCommand};
    
    return [[ADDiscoverItemViewModel alloc]initWithParam:param];
}

- (ADDiscoverItemViewModel *)showCasesViewModel {
    UIImage *itemIcon = [UIImage new];
    RACCommand *itemCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        return [RACSignal empty];
    }];
    
    NSDictionary *param = @{@"itemName" : @"ShowCases",
                            @"itemIcon" : itemIcon,
                            @"itemCommand": itemCommand};
    
    return [[ADDiscoverItemViewModel alloc]initWithParam:param];
}

- (ADDiscoverItemViewModel *)searchViewModel {
    UIImage *itemIcon = [UIImage new];
    RACCommand *itemCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        return [RACSignal empty];
    }];
    
    NSDictionary *param = @{@"itemName" : @"Search",
                            @"itemIcon" : itemIcon,
                            @"itemCommand": itemCommand};
    
    return [[ADDiscoverItemViewModel alloc]initWithParam:param];
}

- (ADDiscoverItemViewModel *)browseViewModel {
    UIImage *itemIcon = [UIImage new];
    RACCommand *itemCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        return [RACSignal empty];
    }];
    
    NSDictionary *param = @{@"itemName" : @"Browse",
                            @"itemIcon" : itemIcon,
                            @"itemCommand": itemCommand};
    
    return [[ADDiscoverItemViewModel alloc]initWithParam:param];
}

@end
