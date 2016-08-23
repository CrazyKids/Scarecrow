//
//  ADFollowersViewModel.m
//  Scarecrow
//
//  Created by duanhongjin on 8/20/16.
//  Copyright © 2016 duanhongjin. All rights reserved.
//

#import "ADFollowersViewModel.h"
#import "OCTUser+Persistence.h"

@implementation ADFollowersViewModel

- (void)initialize {
    [super initialize];
    
    self.title = @"Followers";
}

- (RACSignal *)fetchRemoteDataSignalWithPage:(int)page {
    @weakify(self);
    return [[[[[[[ADPlatformManager sharedInstance].client fetchFollowersForUser:self.user offset:[self offsetForPage:page] perPage:self.pageStep]take:self.pageStep]collect]map:^id(NSArray *userArray) {
        for (OCTUser *user in userArray) {
            if (self.isCurrentUser) {
                user.followersStatus = ADFollowStatusYes;
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
            [OCTUser ad_updateFollowerStatus:userArray];
        }
    }];
}

@end
