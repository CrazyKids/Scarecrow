//
//  ADReposSettingsViewModel.m
//  Scarecrow
//
//  Created by duanhongjin on 16/9/19.
//  Copyright © 2016年 duanhongjin. All rights reserved.
//

#import "ADReposSettingsViewModel.h"
#import "OCTRepository+Persistence.h"
#import "ADUserInfoViewModel.h"
#import "ADReposQRCodeViewModel.h"

@interface ADReposSettingsViewModel ()

@property (strong, nonatomic) OCTRepository *repos;

@end

@implementation ADReposSettingsViewModel

- (instancetype)initWithParam:(NSDictionary *)param {
    self = [super initWithParam:param];
    if (self) {
        self.repos = param[@"repos"];
    }
    return self;
}

- (void)initialize {
    [super initialize];
    
    self.bShouldPullToRefresh = NO;
    
    self.dataSourceArray = @[
                             @[@(ADReposSettingDataOwner)],
                             @[@(ADReposSettingDataQRCode)],
                             ];
    
    @weakify(self);
    RACSignal *fetchLocalDataSignal = [RACSignal return:[self fetchLocalData]];
    RACSignal *fetchRemoteDataSignal = [self.fetchRemoteDataCommamd.executionSignals switchToLatest];
    [[[fetchLocalDataSignal merge:fetchRemoteDataSignal]deliverOnMainThread]subscribeNext:^(OCTRepository *repos) {
        @strongify(self);
        
        [self willChangeValueForKey:@"repos"];
        [self.repos mergeValuesForKeysFromModel:repos];
        [self didChangeValueForKey:@"repos"];
    }];
    
    self.didSelectCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(NSIndexPath *indexPath) {
        @strongify(self);
        
        NSInteger section = indexPath.section;
        NSInteger row = indexPath.row;
        
        ADReposSettingData data = [self.dataSourceArray[section][row] integerValue];
        switch (data) {
            case ADReposSettingDataOwner: {
                NSDictionary *dic = @{@"login" : self.repos.ownerLogin ?: @"",
                                      @"avatarURL" : self.repos.ownerAvatarURL.absoluteString ?: @""};
                
                ADUserInfoViewModel *viewModel = [[ADUserInfoViewModel alloc]initWithParam:@{@"user" : dic}];
                [self pushViewControllerWithViewModel:viewModel];
                
                break;
            }
            case ADReposSettingDataQRCode: {
                ADReposQRCodeViewModel *viewModel = [[ADReposQRCodeViewModel alloc]initWithParam:@{@"repos" : self.repos}];
                [self pushViewControllerWithViewModel:viewModel];
                
                break;
            }
            default:
                break;
        }
        return [RACSignal empty];
    }];
}

- (id)fetchLocalData {
    return [OCTRepository ad_fetchFullRepos:self.repos];
}

- (RACSignal *)fetchRemoteDataSignalWithPage:(int)page {
    return [[ADPlatformManager sharedInstance].client fetchRepositoryWithName:self.repos.name owner:self.repos.ownerLogin];
}

@end
