//
//  ADFollowingViewModel.m
//  Scarecrow
//
//  Created by duanhongjin on 8/2/16.
//  Copyright © 2016 duanhongjin. All rights reserved.
//

#import "ADFollowingViewModel.h"
#import "OCTUser+Persistence.h"

@implementation ADFollowingViewModel

- (RACSignal *)fetchRemoteDataSignalWithPage:(int)page {
    @weakify(self);
    return [[[[[[[ADPlatformManager sharedInstance].client fetchFollowingForUser:self.user offset:[self offsetForPage:page] perPage:self.pageStep]take:self.pageStep]collect]map:^id(NSArray *userArray) {
        for (OCTUser *user in userArray) {
            if (self.isCurrentUser) {
                user.followingStatus = ADFollowStatusYes;
            }
        }
        return userArray;
    }]map:^id(NSArray *userArray) {
        @strongify(self);
        if (page == 1) {
            for (OCTUser *user in userArray) {
                if (user.followingStatus == ADFollowStatusYes) {
                    continue;
                }
                
                for (OCTUser *preUser in self.userArray) {
                    if ([user.objectID isEqualToString:preUser.objectID]) {
                        user.followingStatus = preUser.followingStatus;
                        break;
                    }
                }
            }
        } else {
            userArray = @[(self.userArray ?: @[]).rac_sequence, userArray.rac_sequence].rac_sequence.flatten.array;
        }
        
        return userArray;
    }] doNext:^(NSArray *userArray) {
        if (self.isCurrentUser) {
            [OCTUser ad_updateUsers:userArray];
            [OCTUser ad_updateFollowingStatus:userArray];
        }
    }];
}

@end
