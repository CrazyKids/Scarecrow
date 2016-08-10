//
//  OCTUser+Persistence.m
//  Scarecrow
//
//  Created by duanhongjin on 8/2/16.
//  Copyright © 2016 duanhongjin. All rights reserved.
//

#import "OCTUser+Persistence.h"
#import "SSKeychain+Scarecrow.h"

static NSString *const kUserPersistenceTag = @"user_persistence_tag";

@implementation OCTUser (Persistence)

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
    NSString *tag = [NSString stringWithFormat:@"%@_%@", kUserPersistenceTag, rawLogin];
    NSData *data = [[NSUserDefaults standardUserDefaults]objectForKey:tag];
    return [NSKeyedUnarchiver unarchiveObjectWithData:data];
}

- (void)ad_update {
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self];
    NSString *tag = [NSString stringWithFormat:@"%@_%@", kUserPersistenceTag, self.rawLogin];
    [[NSUserDefaults standardUserDefaults]setObject:data forKey:tag];
    
    [[NSUserDefaults standardUserDefaults]synchronize];
}

@end
