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

// user operation
- (BOOL)updateUser:(OCTUser *)user;
- (OCTUser *)fetchUserWithLogin:(NSString *)login;
- (OCTUser *)fetchUserWithRawLogin:(NSString *)rawLogin;

- (BOOL)updateFollowingStatus:(NSArray *)userArray;
- (BOOL)updateFollowerStatus:(NSArray *)userArray;

- (BOOL)followeUser:(OCTUser *)user;
- (BOOL)unfollowUser:(OCTUser *)user;

// repos operation
- (BOOL)updateRepos:(OCTRepository *)repos;
- (BOOL)updateStarStatus:(NSArray *)reposArray;

- (NSArray *)fetchFollowingWithPage:(int)page pageStep:(int)pageStep;
- (NSArray *)fetchFollowersWithPage:(int)page pageStep:(int)pageStep;

- (NSArray *)fetchRepos;
- (NSArray *)fetchStarredRepos;
- (NSArray *)fetchPublicReposWithPage:(int)page pageStep:(int)pageStep;
- (NSArray *)fetchStarredReposWithPage:(int)page pageStep:(int)pageStep;
- (OCTRepository *)fetchFullRepos:(OCTRepository *)repos;

@end
