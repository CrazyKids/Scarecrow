//
//  ADUserInfoViewModel.m
//  Scarecrow
//
//  Created by duanhongjin on 8/17/16.
//  Copyright © 2016 duanhongjin. All rights reserved.
//

#import "ADUserInfoViewModel.h"
#import "OCTUser+Persistence.h"
#import "ADAvatarHeaderViewModel.h"
#import "OCTClient+Scarecrow.h"

@implementation ADUserInfoViewModel

- (void)initialize {
    [super initialize];
    
    self.title = self.user.login;
    
    self.dataSourceArray = @[
                             @[
                                 @(ADUserInfoDataTypeName),
                                 @(ADUserInfoDataTypeStarred),
                                 @(ADUserInfoDataTypeActivity),
                                 ],
                             @[
                                 @(ADUserInfoDataTypeOrganization),
                                 @(ADUserInfoDataTypeLocation),
                                 @(ADUserInfoDataTypeMail),
                                 @(ADUserInfoDataTypeLink),
                                 ],
                             ];
    
    @weakify(self);
    if (![self.user.objectID isEqualToString:[OCTUser ad_currentUser].objectID]) {
        self.avatarHeaderViewModel.operationCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self);
            if (self.user.followingStatus == ADFollowStatusYes) {
                return [[ADPlatformManager sharedInstance].client ad_unfollowUser:self.user];
            }
            
            if (self.user.followingStatus == ADFollowStatusNo) {
                return [[ADPlatformManager sharedInstance].client ad_followUser:self.user];
            }
            
            return [RACSignal empty];
        }];
    }
    
    if (self.user.followingStatus == ADFollowStatusUnknown) {
        [[[ADPlatformManager sharedInstance].client doesFollowUser:self.user]subscribeNext:^(NSNumber *following) {
            @strongify(self);
            if ([following boolValue]) {
                self.user.followingStatus = ADFollowStatusYes;
            } else {
                self.user.followingStatus = ADFollowStatusNo;
            }
        }];
    }
}

@end
