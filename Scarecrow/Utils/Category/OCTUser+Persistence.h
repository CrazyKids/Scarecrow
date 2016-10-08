//
//  OCTUser+Persistence.h
//  Scarecrow
//
//  Created by duanhongjin on 8/2/16.
//  Copyright © 2016 duanhongjin. All rights reserved.
//

#import <OctoKit/OctoKit.h>

typedef NS_ENUM(NSInteger, ADFollowStatus) {
    ADFollowStatusUnknown,
    ADFollowStatusYes,
    ADFollowStatusNo,
};

@interface OCTUser (Persistence)

@property (assign, nonatomic) ADFollowStatus followingStatus;
@property (assign, nonatomic) ADFollowStatus followersStatus;

+ (instancetype)ad_currentUser;
+ (instancetype)ad_userWithRawLogin:(NSString *)rawLogin server:(OCTServer *)server;
+ (instancetype)ad_fetchUserWithRawLogin:(NSString *)rawLogin;
+ (instancetype)ad_fetchUserWithLogin:(NSString *)login;

- (void)ad_update;

+ (BOOL)ad_updateUsers:(NSArray *)userArray;
+ (BOOL)ad_updateFollowerStatus:(NSArray *)userArray;
+ (BOOL)ad_updateFollowingStatus:(NSArray *)userArray;

+ (BOOL)ad_followUser:(OCTUser *)user;
+ (BOOL)ad_unfollowUser:(OCTUser *)user;

+ (NSArray *)ad_fetchFollowingWithPage:(int)page pageStep:(int)pageStep;
+ (NSArray *)ad_fetchFollowersWithPage:(int)page pageStep:(int)pageStep;

- (BOOL)ad_increaseFollowers;
- (BOOL)ad_increaseFollowing;

- (BOOL)ad_decreaseFollowers;
- (BOOL)ad_decreaseFollowing;

@end
