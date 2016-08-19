//
//  OCTUser+Persistence.h
//  Scarecrow
//
//  Created by duanhongjin on 8/2/16.
//  Copyright © 2016 duanhongjin. All rights reserved.
//

#import <OctoKit/OctoKit.h>

typedef NS_ENUM(NSInteger, OCTFollowStatus) {
    ADFollowStatusUnknown,
    ADFollowStatusYes,
    ADFollowStatusNo,
};

@interface OCTUser (Persistence)

@property (assign, nonatomic) OCTFollowStatus followingStatus;

+ (instancetype)ad_currentUser;
+ (instancetype)ad_userWithRawLogin:(NSString *)rawLogin server:(OCTServer *)server;
+ (instancetype)ad_fetchUserWithRawLogin:(NSString *)rawLogin;
+ (instancetype)ad_fetchUserWithLogin:(NSString *)login;

- (BOOL)ad_followUser:(OCTUser *)user;
- (BOOL)ad_unfollowUser:(OCTUser *)user;

- (void)ad_update;

@end
