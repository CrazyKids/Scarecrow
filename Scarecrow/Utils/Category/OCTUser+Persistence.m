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

static NSString* const kUserPersistenceTag = @"user_persistence_tag";
static NSString* const kRawLoginMapTag = @"user_rawlogin_tag";

@implementation OCTUser (Persistence)

- (void)setFollowingStatus:(OCTFollowStatus)followingStatus {
    objc_setAssociatedObject(self, @selector(followingStatus), @(followingStatus), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [self ad_update];
}

- (OCTFollowStatus)followingStatus {
    return [objc_getAssociatedObject(self, _cmd) integerValue];
}

+ (instancetype)ad_currentUser {
    OCTUser *user = [ADPlatformManager sharedInstance].client.user;
    if (!user) {
        user = [self ad_fetchUserWithRawLogin:[SSKeychain username]];
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
    
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [dic setValue:rawLogin forKey:@"rawLogin"];
    [dic setValue:user.login forKey:@"login"];
    [dic setValue:server.baseURL forKey:@"baseURL"];
    
    return [self modelWithDictionary:dic error:nil];
}

+ (instancetype)ad_fetchUserWithRawLogin:(NSString *)rawLogin {
    NSString *mapTag = [NSString stringWithFormat:@"%@_%@", kRawLoginMapTag, rawLogin];
    NSString *login = [[NSUserDefaults standardUserDefaults]objectForKey:mapTag];
    
    return [self ad_fetchUserWithLogin:login];
}

+ (instancetype)ad_fetchUserWithLogin:(NSString *)login {
    NSString *tag = [NSString stringWithFormat:@"%@_%@", kUserPersistenceTag, login];
    NSData *data = [[NSUserDefaults standardUserDefaults]objectForKey:tag];
    
    if (!data) {
        return nil;
    }
    
    return [NSKeyedUnarchiver unarchiveObjectWithData:data];
}

- (void)ad_update {
    NSString *mapTag = [NSString stringWithFormat:@"%@_%@", kRawLoginMapTag, self.rawLogin];
    [[NSUserDefaults standardUserDefaults]setObject:self.login forKey:mapTag];
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self];
    NSString *tag = [NSString stringWithFormat:@"%@_%@", kUserPersistenceTag, self.login];
    [[NSUserDefaults standardUserDefaults]setObject:data forKey:tag];
    
    [[NSUserDefaults standardUserDefaults]synchronize];
}

- (BOOL)ad_followUser:(OCTUser *)user {
    user.followingStatus = ADFollowStatusYes;
    [user ad_increaseFollowing];
    [user ad_update];
    
    [self ad_increaseFollowers];
    [self ad_update];
    
    return YES;
}

- (BOOL)ad_unfollowUser:(OCTUser *)user {
    user.followingStatus = ADFollowStatusNo;
    [user ad_decreaseFollowing];
    [user ad_update];
    
    [self ad_decreaseFollowers];
    [self ad_update];
    
    return YES;
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
    NSUInteger followers = self.followers - 1;
    [self setValue:@(followers) forKey:@"followers"];
    
    return YES;
}

- (BOOL)ad_decreaseFollowing {
    NSUInteger following = self.following - 1;
    [self setValue:@(following) forKey:@"following"];
    
    return YES;
}

@end
