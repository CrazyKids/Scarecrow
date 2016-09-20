//
//  ADProfileViewModel.m
//  Scarecrow
//
//  Created by duanhongjin on 8/2/16.
//  Copyright © 2016 duanhongjin. All rights reserved.
//

#import "ADProfileViewModel.h"
#import "ADAvatarHeaderViewModel.h"
#import "OCTUser+Persistence.h"
#import "ADSetttingsViewModel.h"
#import "ADFollowersViewModel.h"
#import "ADFollowingViewModel.h"
#import "ADPublicReposViewModel.h"
#import "ADStarredReposViewModel.h"
#import "ADPublicActivityViewModel.h"
#import "ADQRCodeViewerController.h"
#import "ADUserQRCodeViewModel.h"

NSString* const kDefaultPlaceHolder = @"Not Set";

@interface ADProfileViewModel ()

@property (strong, nonatomic) NSString *compay;
@property (strong, nonatomic) NSString *location;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *blog;

@property (strong, nonatomic) ADAvatarHeaderViewModel *avatarHeaderViewModel;

@end

@implementation ADProfileViewModel

- (instancetype)initWithParam:(NSDictionary *)param {
    self = [super initWithParam:param];
    if (self) {
        id user = param[@"user"];
        
        if ([user isKindOfClass:[OCTUser class]]) {
            self.user = param[@"user"];
        } else if ([user isKindOfClass:[NSDictionary class]]) {
            self.user = [OCTUser modelWithDictionary:user error:nil];
        } else {
            self.user = [OCTUser ad_currentUser];
        }

    }
    return self;
}

- (void)initialize {
    [super initialize];
    
    self.dataSourceArray = @[
                             @[
                                 @(ADUserInfoDataTypeStarred),
                                 ],
                             @[
                                 @(ADUserInfoDataTypeOrganization),
                                 @(ADUserInfoDataTypeLocation),
                                 @(ADUserInfoDataTypeMail),
                                 @(ADUserInfoDataTypeLink),
                                 @(ADUserInfoDataTypeGenerateQRCode),
                                 ],
                             ];
    
    self.bShouldPullToRefresh = NO;
    self.avatarHeaderViewModel = [[ADAvatarHeaderViewModel alloc]initWithUser:self.user];
    
    @weakify(self);
    self.avatarHeaderViewModel.followersCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        
        ADFollowersViewModel *viewModel = [[ADFollowersViewModel alloc]initWithParam:@{@"user" : self.user}];
        [self pushViewControllerWithViewModel:viewModel];
        
        return [RACSignal empty];
    }];
    
    self.avatarHeaderViewModel.followingCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        
        ADFollowingViewModel *viewModel = [[ADFollowingViewModel alloc]initWithParam:@{@"user" : self.user}];
        [self pushViewControllerWithViewModel:viewModel];
        
        return [RACSignal empty];
    }];
    
    self.avatarHeaderViewModel.reposCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        
        ADPublicReposViewModel *viewModel = [[ADPublicReposViewModel alloc]initWithParam:@{@"user" : self.user}];
        [self pushViewControllerWithViewModel:viewModel];
        
        return [RACSignal empty];
    }];
    
    id (^map)(NSString *) = ^(NSString *value) {
        if (value.length && ![value isEqualToString:@"null"]) {
            return value;
        }
        
        return kDefaultPlaceHolder;
    };
    
    RAC(self, compay) = [RACObserve(self.user, company) map:map];
    RAC(self, location) = [RACObserve(self.user, location) map:map];
    RAC(self, email) = [RACObserve(self.user, email) map:map];
    RAC(self, blog) = [RACObserve(self.user, blog) map:map];
    
    RACSignal *fetchLocalDataSignal = [RACSignal return:[self fetchLocalData]];
    RACSignal *fetchRemoteDataSignal = self.fetchRemoteDataCommamd.executionSignals.switchToLatest;
    
    [[[fetchLocalDataSignal merge:fetchRemoteDataSignal]deliverOnMainThread] subscribeNext:^(OCTUser *user) {
        @strongify(self)
        [self willChangeValueForKey:@"user"];
        user.followingStatus = self.user.followingStatus;
        [self.user mergeValuesForKeysFromModel:user];
        [self didChangeValueForKey:@"user"];
    }];
    
    
    self.didSelectCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(NSIndexPath *indexPath) {
        @strongify(self);
        ADUserInfoDataType type = [self.dataSourceArray[indexPath.section][indexPath.row] integerValue];
        switch (type) {
            case ADUserInfoDataTypeStarred: {
                ADStarredReposViewModel *viewModel = [[ADStarredReposViewModel alloc]initWithParam:@{@"user" : self.user}];
                [self pushViewControllerWithViewModel:viewModel];
                
                break;
            }
            case ADUserInfoDataTypeActivity: {
                ADPublicActivityViewModel *viewModel = [[ADPublicActivityViewModel alloc]initWithParam:@{@"user" : self.user}];
                [self pushViewControllerWithViewModel:viewModel];
                
                break;
            }
            case ADUserInfoDataTypeMail:
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"mailto:%@", self.email]]];
                break;
            case ADUserInfoDataTypeLink:
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.blog]];
                break;
            case ADUserInfoDataTypeGenerateQRCode:
            {
                ADUserQRCodeViewModel *viewModel = [[ADUserQRCodeViewModel alloc] initWithParam:@{@"user" : self.user}];
                [self pushViewControllerWithViewModel:viewModel];
            }
                break;
            default:
                break;
        }
        return [RACSignal empty];
    }];
}

- (OCTUser *)fetchLocalData {
    return [OCTUser ad_fetchUserWithLogin:self.user.login];
}

- (RACSignal *)fetchRemoteDataSignalWithPage:(int)page {
    return [[[[ADPlatformManager sharedInstance].client fetchUserInfoForUser:self.user]retry:3]doNext:^(OCTUser *user) {
        if (!user.rawLogin.length) {
            [user setValue:user.login forKey:@"rawLogin"];
        }
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [user ad_update];
        });
    }];
}

@end
