//
//  OCTClient+Scarecrow.m
//  Scarecrow
//
//  Created by duanhongjin on 8/18/16.
//  Copyright © 2016 duanhongjin. All rights reserved.
//

#import "OCTClient+Scarecrow.h"
#import "OCTUser+Persistence.h"

@implementation OCTClient (Scarecrow)

- (RACSignal *)ad_followUser:(OCTUser *)user {
    if (user.followingStatus == ADFollowStatusYes) {
        return [RACSignal empty];
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.user ad_followUser:user];
    });
    
    return [self followUser:user];
}

- (RACSignal *)ad_unfollowUser:(OCTUser *)user {
    if (user.followingStatus == ADFollowStatusNo) {
        return [RACSignal empty];
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.user ad_unfollowUser:user];
    });
    
    return [self unfollowUser:user];
}

@end
