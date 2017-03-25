//
//  ADTrendingReposViewModel.m
//  Scarecrow
//
//  Created by duanhongjin on 2017/3/23.
//  Copyright © 2017年 duanhongjin. All rights reserved.
//

#import "ADTrendingReposViewModel.h"
#import "ADViewModelService.h"
#import "ADRepositoryService.h"

@implementation ADTrendingReposViewModel

- (instancetype)initWithParam:(NSDictionary *)param {
    self = [super initWithParam:param];
    if (self) {
        self.sinceDic = param[@"since"];
        self.languageDic = param[@"language"];
    }
    
    return self;
}

- (void)initialize {
    [super initialize];
    
    RACSignal *sinceSignal = [[RACObserve(self, sinceDic)
                               map:^(NSDictionary *since) {
                                   return since[@"slug"];
                               }] distinctUntilChanged];
    
    RACSignal *languageSignal = [[RACObserve(self, languageDic)
                                  map:^(NSDictionary *language) {
                                      return language[@"slug"];
                                  }] distinctUntilChanged];
    
    @weakify(self);
    [[[RACSignal combineLatest:@[sinceSignal, languageSignal]] doNext:^(id x) {
        @strongify(self);
        self.dataSourceArray = nil;
    }] subscribeNext:^(id x) {
        @strongify(self);
        [self.fetchRemoteDataCommamd execute:nil];
    }];
}

- (NSArray *)fetchLocalData { 
    return nil;
}

- (RACSignal *)fetchRemoteDataSignalWithPage:(int)page {
    ADRepositoryService *service = [ADPlatformManager sharedInstance].service.reposService;
    
    NSString *since = self.sinceDic ? self.sinceDic[@"slug"] : @"";
    NSString *language = self.languageDic ? self.languageDic[@"slug"] : @"";
    
    return [service fetchTrendingRepositoriesWithSince:since language:language];
}

- (ADReposViewModelOptions)options {
    ADReposViewModelOptions option = ADReposViewModelOptionsShowOwnerLogin;
    
    return option;
}


@end
