//
//  OCTUser+Persistence.m
//  Scarecrow
//
//  Created by duanhongjin on 8/2/16.
//  Copyright © 2016 duanhongjin. All rights reserved.
//

#import "OCTUser+Persistence.h"
#import "SSKeychain+Scarecrow.h"
#import <objc/runtime.h>
#import "ADDataBaseManager.h"

@implementation OCTUser (Persistence)

- (void)setFollowingStatus:(ADFollowStatus)followingStatus {
    objc_setAssociatedObject(self, @selector(followingStatus), @(followingStatus), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (ADFollowStatus)followingStatus {
    return [objc_getAssociatedObject(self, _cmd) integerValue];
}

- (void)setFollowersStatus:(ADFollowStatus)followersStatus {
    objc_setAssociatedObject(self, @selector(followersStatus), @(followersStatus), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (ADFollowStatus)followersStatus {
    return [objc_getAssociatedObject(self, _cmd) integerValue];
}

+ (ADDataBase *)database {
    return [ADPlatformManager sharedInstance].dataBaseManager.dataBase;
}

+ (instancetype)ad_currentUser {
    OCTUser *user = [ADPlatformManager sharedInstance].client.user;
    if (!user) {
        user = [[self database]fetchUserWithRawLogin:[SSKeychain username]];
        OCTClient *client = [OCTClient authenticatedClientWithUser:user token:[SSKeychain accessToken]];
        [ADPlatformManager sharedInstance].client = client;
    }
    
    return user;
}

+ (instancetype)ad_userWithRawLogin:(NSString *)rawLogin server:(OCTServer *)server {
    NSParameterAssert(rawLogin.length > 0);
    NSParameterAssert(server);
    
    OCTUser *user = [self ad_fetchUserWithRawLogin:rawLogin];
    NSParameterAssert(user && user.login.length > 0);
    
    [user setValue:server.baseURL forKey:@"baseURL"];
    
    return user;
}

+ (instancetype)ad_fetchUserWithRawLogin:(NSString *)rawLogin {
    return [[self database]fetchUserWithRawLogin:rawLogin];
}

+ (instancetype)ad_fetchUserWithLogin:(NSString *)login {
    return [[self database]fetchUserWithLogin:login];
}

- (void)ad_update {
    [[[self class]database]updateUser:self];
}

+ (BOOL)ad_updateUsers:(NSArray *)userArray {
    for (OCTUser *user in userArray) {
        if (![[self database]updateUser:user]) {
            return NO;
        }
    }
    
    return YES;
}

+ (BOOL)ad_updateFollowerStatus:(NSArray *)userArray {
    return [[self database]updateFollowerStatus:userArray];
}

+ (BOOL)ad_updateFollowingStatus:(NSArray *)userArray {
    return [[self database]updateFollowingStatus:userArray];
}

+ (BOOL)ad_followUser:(OCTUser *)user {
    return [[self database]followeUser:user];
}

+ (BOOL)ad_unfollowUser:(OCTUser *)user {
    return [[self database]unfollowUser:user];
}

+ (NSArray *)ad_fetchFollowingWithPage:(int)page pageStep:(int)pageStep {
    return [[self database]fetchFollowingWithPage:page pageStep:pageStep];
}

+ (NSArray *)ad_fetchFollowersWithPage:(int)page pageStep:(int)pageStep {
    return [[self database]fetchFollowersWithPage:page pageStep:pageStep];
}

- (BOOL)ad_increaseFollowers {
    NSUInteger followers = self.followers + 1;
    [self setValue:@(followers) forKey:@"followers"];
    
    return YES;
}

- (BOOL)ad_increaseFollowing {
    NSUInteger following = self.following + 1;
    [self setValue:@(following) forKey:@"following"];
    
    return YES;
}

- (BOOL)ad_decreaseFollowers {
    if (self.followers == 0) {
        return YES;
    }
    
    NSUInteger followers = self.followers - 1;
    [self setValue:@(followers) forKey:@"followers"];
    
    return YES;
}

- (BOOL)ad_decreaseFollowing {
    if (self.following == 0) {
        return YES;
    }
    
    NSUInteger following = self.following - 1;
    [self setValue:@(following) forKey:@"following"];
    
    return YES;
}


@end
