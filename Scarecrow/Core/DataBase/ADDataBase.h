//
//  ADDataBase.h
//  Scarecrow
//
//  Created by duanhongjin on 7/15/16.
//  Copyright © 2016 duanhongjin. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FMDatabaseQueueV2;

@interface ADDataBase : NSObject {
    FMDatabaseQueueV2   *_dataBaseQueue;
}

+ (NSArray *)tableCreateSQLSentences;
+ (NSArray *)tableDropSQLSentences;

- (instancetype)initWithDataBaseQueue:(FMDatabaseQueueV2 *)dataBaseQueue;

- (BOOL)updateUser:(OCTUser *)user;
- (OCTUser *)fetchUserWithLogin:(NSString *)login;
- (OCTUser *)fetchUserWithRawLogin:(NSString *)rawLogin;

- (BOOL)updateFollowingStatus:(NSArray *)userArray;
- (BOOL)updateFollowerStatus:(NSArray *)userArray;

- (BOOL)followeUser:(OCTUser *)user;
- (BOOL)unfollowUser:(OCTUser *)user;

@end
