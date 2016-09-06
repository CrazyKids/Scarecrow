//
//  ADReposViewModel.m
//  Scarecrow
//
//  Created by duanhongjin on 16/8/30.
//  Copyright © 2016年 duanhongjin. All rights reserved.
//

#import "ADReposViewModel.h"
#import "OCTUser+Persistence.h"
#import "OCTRepository+Persistence.h"
#import "ADReposItemViewModel.h"

@interface ADReposViewModel ()

@property (strong, nonatomic) OCTUser *user;
@property (strong, nonatomic) NSArray<OCTRepository *> *reposArray;

@end

@implementation ADReposViewModel

- (instancetype)initWithParam:(NSDictionary *)param {
    self = [super initWithParam:param];
    if (self) {
        self.user = param[@"user"] ?: [OCTUser ad_currentUser];
    }
    return self;
}

- (BOOL)isCurrentUser {
    return [self.user.objectID isEqualToString:[OCTUser ad_currentUser].objectID];
}

- (void)initialize {
    [super initialize];
    
    @weakify(self);
    self.didSelectCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        return [RACSignal empty];
    }];
    
    RACSignal *starredSignal = [[[NSNotificationCenter defaultCenter]rac_addObserverForName:AD_NOTIFICATION_STARRED_UPDATE object:nil]filter:^BOOL(id value) {
        return NO;
    }];
    
    RACSignal *fetchLocalDataSignal = [[starredSignal startWith:nil]map:^id(id value) {
        @strongify(self);
        return [self fetchLocalData];
    }];
    
    RACSignal *fetchRemoteDataSignal = [self.fetchRemoteDataCommamd.executionSignals.switchToLatest doNext:^(NSArray *reposArray) {
        @strongify(self);
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            if (self.options & ADReposOptionUpdate) {
                [self updateRepos:reposArray];
            }
       });
    }];
    
    RAC(self, reposArray) = [fetchLocalDataSignal merge:fetchRemoteDataSignal];
    RAC(self, dataSourceArray) = [[[RACObserve(self, reposArray) map:^id(NSArray *reposArray) {
        return [OCTRepository ad_matchStarredStatus:reposArray];
    }]doNext:^(NSArray *reposArray) {
        
    }]flattenMap:^RACStream *(NSArray *reposArray) {
        @strongify(self);
        return [self dataSourceSignalWithRopse:reposArray];
    }];
}

- (NSArray *)fetchLocalData {
    return [OCTRepository ad_fetchRepos];
}

- (void)updateRepos:(NSArray *)reposArray {
    [OCTRepository ad_update:reposArray];
}

- (RACSignal *)fetchRemoteDataSignalWithPage:(int)page {
    return [[[ADPlatformManager sharedInstance].client fetchUserRepositories]collect];
}

- (RACSignal *)dataSourceSignalWithRopse:(NSArray *)reposArray {
    if (!reposArray) {
        return [RACSignal empty];
    }
    
    NSArray *viewModelArray = [[reposArray rac_sequence]map:^id(OCTRepository *repos) {
        return [[ADReposItemViewModel alloc]initWithRepos:repos options:self.options];
    }].array;
    
    return [RACSignal return:@[viewModelArray]];
}

- (ADReposOption)options {
    ADReposOption options = 0;
    
    options |= ADReposOptionUpdate;
    
    return 0;
}

@end
