//
//  ADPopularReposViewModel.m
//  Scarecrow
//
//  Created by duanhongjin on 2017/3/25.
//  Copyright © 2017年 duanhongjin. All rights reserved.
//

#import "ADPopularReposViewModel.h"
#import "ADLanguageViewModel.h"

@interface ADPopularReposViewModel ()

@property (strong, nonatomic) NSDictionary *language;
@property (strong, nonatomic) RACCommand *rightBarButtonCommand;

@end

@implementation ADPopularReposViewModel

- (void)initialize {
    [super initialize];
    
    NSDictionary *language = (NSDictionary *)[[ADPlatformManager sharedInstance].cacheMgr objectForKey:kPopularReposLanguageCacheKey];
    
    self.language = language ?: @{@"name":@"All Languages", @"slug":@""};
    
    RAC(self, title) = [RACObserve(self, language)map:^id(NSDictionary *value) {
        return value[@"name"];
    }];
    
    @weakify(self);
    self.rightBarButtonCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        
        NSDictionary *param = @{@"language" : self.language ?: @{}};
        ADLanguageViewModel *viewModel = [[ADLanguageViewModel alloc]initWithParam:param];
        viewModel.callback = ^(NSDictionary *language) {
            @strongify(self);
            self.language = language;
            
            [[ADPlatformManager sharedInstance].cacheMgr setObject:language forKey:kPopularReposLanguageCacheKey];
        };
        
        [self pushViewControllerWithViewModel:viewModel];
        
        return [RACSignal empty];
    }];
    
    [[[[RACObserve(self, language) map:^(NSDictionary *language) {
        return language[@"slug"];
    }] distinctUntilChanged] doNext:^(id x) {
          @strongify(self)
          self.dataSourceArray = nil;
    }] subscribeNext:^(id x) {
        @strongify(self)
        [self.fetchRemoteDataCommamd execute:nil];
    }];
}

- (NSArray *)fetchLocalData {
    return nil;
}

- (RACSignal *)fetchRemoteDataSignalWithPage:(int)page {
    return [[ADPlatformManager sharedInstance].client fetchPopularRepositoriesWithLanguage:self.language[@"slug"]];
}

- (ADReposViewModelOptions)options {
    ADReposViewModelOptions option = ADReposViewModelOptionsShowOwnerLogin;
    
    return option;
}

@end
