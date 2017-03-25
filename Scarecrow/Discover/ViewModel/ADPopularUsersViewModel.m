//
//  ADPopularUsersViewModel.m
//  Scarecrow
//
//  Created by duanhongjin on 2017/3/19.
//  Copyright © 2017年 duanhongjin. All rights reserved.
//

#import "ADPopularUsersViewModel.h"
#import <ZRPopView/ZRPopView.h>
#import "ADLanguageViewModel.h"
#import "ADCountriesViewModel.h"

@interface ADPopularUsersViewModel ()

@property (strong, nonatomic) RACCommand *rightBarButtonCommand;

@property (strong, nonatomic) NSArray *popoverMenus;
@property (strong, nonatomic) RACCommand *popoverCommand;

@end

@implementation ADPopularUsersViewModel

- (void)initialize {
    [super initialize];
    
    self.title = @"Popluar Users";
    
    NSDictionary *language = (NSDictionary *)[[ADPlatformManager sharedInstance].cacheMgr objectForKey:kPopularUsersLanguageCacheKey];
    NSDictionary *country = [(NSDictionary *)[ADPlatformManager sharedInstance].cacheMgr objectForKey:kPopularUserCountryCacheKey];
    
    self.language = language ?: @{@"name":@"All Languages", @"slug":@""};
    self.country = country ?: @{@"name":@"All Countries", @"slug":@""};
    
    self.popoverMenus = @[@{kZRPopoverViewTitle:@"Countries"},
                          @{kZRPopoverViewTitle:@"Languages"}];
    
    @weakify(self);
    self.popoverCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(NSNumber *index) {
        @strongify(self);
        switch (index.integerValue) {
            case 0: {
                ADCountriesViewModel *viewModel = [[ADCountriesViewModel alloc]initWithParam:@{@"country":self.country?:@{}}];
                viewModel.callback = ^(NSDictionary *country) {
                    self.country = country;
                    
                    [[ADPlatformManager sharedInstance].cacheMgr setObject:language forKey:kPopularUserCountryCacheKey];
                };
                [self pushViewControllerWithViewModel:viewModel];
                
                break;
            }
            case 1: {
                ADLanguageViewModel *viewModel = [[ADLanguageViewModel alloc]initWithParam:@{@"language":self.language?:@{}}];
                viewModel.callback = ^(NSDictionary *language) {
                    self.language = language;
                    
                    [[ADPlatformManager sharedInstance].cacheMgr setObject:language forKey:kPopularUsersLanguageCacheKey];
                };
                [self pushViewControllerWithViewModel:viewModel];
                
                break;
            }
            default:
                break;
        }
        
        return [RACSignal empty];
    }];
    
    RACSignal *countrySignal = [[RACObserve(self, country)
                               map:^(NSDictionary *since) {
                                   return since[@"slug"];
                               }] distinctUntilChanged];
    
    RACSignal *languageSignal = [[RACObserve(self, language)
                                  map:^(NSDictionary *language) {
                                      return language[@"slug"];
                                  }] distinctUntilChanged];
    
    [[[RACSignal combineLatest:@[countrySignal, languageSignal]] doNext:^(id x) {
        @strongify(self);
        self.dataSourceArray = nil;
    }]subscribeNext:^(id x) {
        @strongify(self)
        [self.fetchRemoteDataCommamd execute:nil];
    }];
}

- (RACSignal *)fetchRemoteDataSignalWithPage:(int)page {
    return [[ADPlatformManager sharedInstance].client fetchPopularUsersWithLocation:self.country[@"slug"] language:self.language[@"slug"]];
}

@end
