//
//  ADUserListViewModel.m
//  Scarecrow
//
//  Created by duanhongjin on 8/20/16.
//  Copyright © 2016 duanhongjin. All rights reserved.
//

#import "ADUserListViewModel.h"
#import "OCTUser+Persistence.h"
#import "ADUserListItemViewModel.h"
#import "ADUserInfoViewModel.h"
#import "OCTClient+Scarecrow.h"

@interface ADUserListViewModel ()

@property (strong, nonatomic) OCTUser *user;

@property (assign, nonatomic) BOOL isCurrentUser;
@property (copy, nonatomic) NSArray *userArray;

@end

@implementation ADUserListViewModel

- (instancetype)initWithParam:(NSDictionary *)param {
    self = [super initWithParam:param];
    if (self) {
        self.user = param[@"user"] ?: [OCTUser ad_currentUser];
    }
    return self;
}

- (void)initialize {
    [super initialize];
    
    @weakify(self);
    
    self.didSelectCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(NSIndexPath *indexPath) {
        @strongify(self);
        
        ADUserListItemViewModel *vmItem = self.dataSourceArray[indexPath.section][indexPath.row];
        ADUserInfoViewModel *vm = [[ADUserInfoViewModel alloc]initWithParam:@{@"user":vmItem.user}];
        ADViewController *vc = [[ADPlatformManager sharedInstance]viewControllerWithViewModel:vm];
        
        [self.ownerVC.navigationController pushViewController:vc animated:YES];
        
        return [RACSignal empty];
    }];
    
    self.operationCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(ADUserListItemViewModel *viewModel) {
        if (viewModel.user.followingStatus == ADFollowStatusYes) {
            [[ADPlatformManager sharedInstance].client ad_unfollowUser:viewModel.user];
        } else if (viewModel.user.followingStatus == ADFollowStatusNo) {
            [[ADPlatformManager sharedInstance].client ad_followUser:viewModel.user];
        }
        
        return [RACSignal empty];
    }];
    
    RACSignal *fetchLocalDataSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        return (RACDisposable *)nil;
    }];
    
    RACSignal *fetchRemoteDataSignal = self.fetchRemoteDataCommamd.executionSignals.switchToLatest;
    RAC(self, userArray) = [fetchLocalDataSignal merge:fetchRemoteDataSignal];
    RAC(self, dataSourceArray) = [RACObserve(self, userArray)map:^id(NSArray *userArray) {
        @strongify(self);
        return [self dataSourceWithUsers:userArray];
    }];
}

- (BOOL)isCurrentUser {
    return [self.user.objectID isEqualToString:[OCTUser ad_currentUser].objectID];
}

- (NSArray *)dataSourceWithUsers:(NSArray *)userArray {
    if (!userArray.count) {
        return nil;
    }
    
    @weakify(self);
    NSArray *viewModelArray = [userArray.rac_sequence map:^id(OCTUser *user) {
        @strongify(self);
        ADUserListItemViewModel *viewModel = [[ADUserListItemViewModel alloc]initWithUser:user];
        if (user.followingStatus == ADFollowStatusUnknown) {
            [[[ADPlatformManager sharedInstance].client doesFollowUser:user]subscribeNext:^(NSNumber *following) {
                if (following.boolValue) {
                    user.followingStatus = ADFollowStatusYes;
                } else {
                    user.followingStatus = ADFollowStatusNo;
                }
            }];
        }
        
        if (![user.objectID isEqualToString:[OCTUser ad_currentUser].objectID]) {
            viewModel.operationCommand = self.operationCommand;
        }
        
        return viewModel;
    }].array;
    
    return @[viewModelArray ?: @[]];
}

@end
