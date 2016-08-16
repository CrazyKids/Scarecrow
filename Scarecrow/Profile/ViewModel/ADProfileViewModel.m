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

static NSString* const kDefaultPlaceHolder = @"";

@interface ADProfileViewModel ()

@property (strong, nonatomic) NSString *compay;
@property (strong, nonatomic) NSString *location;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *blog;

@property (strong, nonatomic) ADAvatarHeaderViewModel *avatarHeaderViewModel;

@end

@implementation ADProfileViewModel

- (void)initialize {
    [super initialize];
    
    self.user = [OCTUser ad_currentUser];
    
    self.avatarHeaderViewModel = [[ADAvatarHeaderViewModel alloc]initWithUser:self.user];
    
    @weakify(self);
    self.avatarHeaderViewModel.followersCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        return [RACSignal empty];
    }];
    
    self.avatarHeaderViewModel.followingCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        return [RACSignal empty];
    }];
    
    self.avatarHeaderViewModel.reposCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
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
    
    [[[fetchLocalDataSignal merge:fetchRemoteDataSignal]deliverOnMainThread]subscribeNext:^(OCTUser *user) {
        @strongify(self);
        [self willChangeValueForKey:@"user"];
        user.followingStatus = self.user.followingStatus;
        [self.user mergeValuesForKeysFromModel:user];
        [self didChangeValueForKey:@"user"];
    }];
}

- (OCTUser *)fetchLocalData {
    return [OCTUser ad_fetchUserWithRawLogin:self.user.rawLogin];
}

- (RACSignal *)fetchRemoteDataSignalWithPage:(int)page {
    return [[[[ADPlatformManager sharedInstance].client fetchUserInfoForUser:self.user]retry:3]doNext:^(OCTUser *user) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [user ad_update];
        });
    }];
}

@end
