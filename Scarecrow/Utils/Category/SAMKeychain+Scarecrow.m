//
//  SAMKeychain+Scarecrow.m
//  Scarecrow
//
//  Created by duanhongjin on 7/8/16.
//  Copyright © 2016 duanhongjin. All rights reserved.
//

#import "SAMKeychain+Scarecrow.h"

NSString *const kDefaultServiceKey = @"com.alexander.scarecrow";
NSString *const kDefaultUsernameKey = @"scarecrow.username";
NSString *const kDefaultAccessTokenKey = @"scarecrow.accesstoken";
NSString *const kDefaultPasswordKey = @"scarecrow.password";

@implementation SAMKeychain (Scarecrow)

+ (BOOL)setUsername:(NSString *)username {
    [[NSUserDefaults standardUserDefaults]setValue:username forKey:kDefaultUsernameKey];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    return YES;
}

+ (BOOL)setAccessToken:(NSString *)accessToken {
    return [self setPassword:accessToken forService:kDefaultServiceKey account:kDefaultAccessTokenKey];
}

+ (BOOL)setPassword:(NSString *)password {
    return [self setPassword:password forService:kDefaultServiceKey account:kDefaultPasswordKey];
}

+ (NSString *)username {
    return [[NSUserDefaults standardUserDefaults]objectForKey:kDefaultUsernameKey];
}

+ (NSString *)accessToken {
    return [self passwordForService:kDefaultServiceKey account:kDefaultAccessTokenKey];
}

+ (NSString *)password {
    return [self passwordForService:kDefaultServiceKey account:kDefaultPasswordKey];
}

+ (void)deleteUsername {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kDefaultUsernameKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)deleteAccessToken {
    [self deletePasswordForService:kDefaultServiceKey account:kDefaultAccessTokenKey];
}

+ (void)deletePassword {
    [self deletePasswordForService:kDefaultServiceKey account:kDefaultPasswordKey];
}

@end
