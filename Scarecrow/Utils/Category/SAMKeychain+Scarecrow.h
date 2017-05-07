//
//  SAMKeychain+Scarecrow.h
//  Scarecrow
//
//  Created by duanhongjin on 7/8/16.
//  Copyright © 2016 duanhongjin. All rights reserved.
//

#import <SAMKeychain/SAMKeychain.h>

@interface SAMKeychain (Scarecrow)

+ (BOOL)setUsername:(NSString *)username;
+ (BOOL)setAccessToken:(NSString *)accessToken;
+ (BOOL)setPassword:(NSString *)password;

+ (NSString *)username;
+ (NSString *)accessToken;
+ (NSString *)password;

+ (void)deleteUsername;
+ (void)deleteAccessToken;
+ (void)deletePassword;

@end
