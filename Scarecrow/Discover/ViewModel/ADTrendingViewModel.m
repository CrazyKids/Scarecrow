//
//  ADTrendingViewModel.m
//  Scarecrow
//
//  Created by duanhongjin on 2017/3/19.
//  Copyright © 2017年 duanhongjin. All rights reserved.
//

#import "ADTrendingViewModel.h"
#import "ADTrendingReposViewModel.h"
#import "YYCache+Scarecrow.h"
#import "ADLanguageViewModel.h"

@interface ADTrendingViewModel ()

@property (strong, nonatomic) NSDictionary *language;

@property (strong, nonatomic) RACCommand *rightBarButtonCommand;

@property (strong, nonatomic) ADTrendingReposViewModel *dailyViewModel;
@property (strong, nonatomic) ADTrendingReposViewModel *weeklyViewModel;
@property (strong, nonatomic) ADTrendingReposViewModel *monthlyViewModel;

@end

@implementation ADTrendingViewModel

- (void)initialize {
    [super initialize];
    
    self.language = [(NSDictionary *)[YYCache sharedInstance]objectForKey:kTrendingLanguageCacheKey];
    if (!self.language) {
        self.language = @{@"name" : @"All Languages", @"slug" : @""};
    }
    
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
            
            [[YYCache sharedInstance]setObject:language forKey:kTrendingLanguageCacheKey];
        };
        
        [self pushViewControllerWithViewModel:viewModel];
        
        return [RACSignal empty];
    }];
    
    self.dailyViewModel = [[ADTrendingReposViewModel alloc]initWithParam:nil];
    self.weeklyViewModel = [[ADTrendingReposViewModel alloc]initWithParam:nil];
    self.monthlyViewModel = [[ADTrendingReposViewModel alloc]initWithParam:nil];
    
    self.dailyViewModel.sinceDic = @{@"name" : @"Today", @"slug" : @"daily"};
    self.weeklyViewModel.sinceDic = @{@"name" : @"This Week", @"slug" : @"weekly"};
    self.monthlyViewModel.sinceDic = @{@"name" : @"This Month", @"slug" : @"monthly"};
    
    RAC(self.dailyViewModel, languageDic) = RACObserve(self, language);
    RAC(self.weeklyViewModel, languageDic) = RACObserve(self, language);
    RAC(self.monthlyViewModel, languageDic) = RACObserve(self, language);
}

@end
