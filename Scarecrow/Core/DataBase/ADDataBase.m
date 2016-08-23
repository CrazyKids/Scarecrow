//
//  ADDataBase.m
//  Scarecrow
//
//  Created by duanhongjin on 7/15/16.
//  Copyright © 2016 duanhongjin. All rights reserved.
//

#import "ADDataBase.h"
#import "FMDatabaseQueueV2.h"
#import <FMDB/FMDB.h>
#import "OCTUser+Persistence.h"

@implementation ADDataBase

+ (NSArray *)tableCreateSQLSentences {
    NSArray *array = @[
                       // user table
                       @"CREATE TABLE IF NOT EXISTS user (id INTEGER PRIMARY KEY, rawLogin TEXT, login TEXT, name TEXT, bio TEXT, email TEXT, avatar_url TEXT, html_url TEXT, blog TEXT, company TEXT, location TEXT, collaborators INTEGER, public_repos INTEGER, owned_private_repos INTEGER, public_gists INTEGER, private_gists INTEGER, followers INTEGER, following INTEGER, disk_usage INTEGER)",
                       
                       @"CREATE TABLE IF NOT EXISTS repos (id INTEGER PRIMARY KEY, name TEXT, owner_login TEXT, owner_avatar_url TEXT, description TEXT, language TEXT, pushed_at TEXT, created_at TEXT, updated_at TEXT, clone_url TEXT, ssh_url TEXT, git_url TEXT, html_url TEXT, default_branch TEXT, private INTEGER, fork INTEGER, watchers_count INTEGER, forks_count INTEGER, stargazers_count INTEGER, open_issues_count INTEGER, subscribers_count INTEGER)",
                       
                       // 比较绕，是user（我）following user（other）
                       @"CREATE TABLE IF NOT EXISTS userFollowingUser (id INTEGER PRIMARY KEY autoincrement, userId INTEGER, dstUserId INTEGER)",
                       
                       @"CREATE TABLE IF NOT EXISTS userStaredRepos (id INTEGER PRIMARY KEY autoincrement, userId INTEGER, reposId INTEGER)",
                       ];
    
    return array;
}

+ (NSArray *)tableDropSQLSentences {
    NSArray *array = @[
                       @"DROP TABLE IF EXISTS user",
                       @"DROP TABLE IF EXISTS repos",
                       @"DROP TABLE IF EXISTS userFollowingUser",
                       @"DROP TABLE IF EXISTS userStaredRepos",
                       ];
    
    return array;
}

- (instancetype)initWithDataBaseQueue:(FMDatabaseQueueV2 *)dataBaseQueue {
    self = [super init];
    if (self) {
        _dataBaseQueue = dataBaseQueue;
    }
    return self;
}

- (BOOL)updateUser:(OCTUser *)user {
    __block BOOL success = NO;
    [_dataBaseQueue updateDatabase:^(FMDatabase *db) {
        NSString *sql = @"REPLACE INTO user(id, rawLogin, login, name, bio, email, avatar_url, html_url, blog, company, location, collaborators, public_repos, owned_private_repos, public_gists, private_gists, followers, following, disk_usage) VALUES(:id, :rawLogin, :login, :name, :bio, :email, :avatar_url, :html_url, :blog, :company, :location, :collaborators, :public_repos, :owned_private_repos, :public_gists, :private_gists, :followers, :following, :disk_usage)";
        success = [db executeQuery:sql withParameterDictionary:[MTLJSONAdapter JSONDictionaryFromModel:user]];
    }];
    
    return success;
}

- (OCTUser *)fetchUserWithLogin:(NSString *)login {
    __block OCTUser *user = nil;
    [_dataBaseQueue queryInDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:@"SELECT * FROM user WHERE login = ?", login];
        if ([rs next]) {
            user = [MTLJSONAdapter modelOfClass:[OCTUser class] fromJSONDictionary:rs.resultDictionary error:nil];
        }
    }];
    
    return user;
}

- (OCTUser *)fetchUserWithRawLogin:(NSString *)rawLogin {
    __block OCTUser *user = nil;
    [_dataBaseQueue queryInDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:@"SELECT * FROM user WHERE rawLogin = ?", rawLogin];
        if ([rs next]) {
            user = [MTLJSONAdapter modelOfClass:[OCTUser class] fromJSONDictionary:rs.resultDictionary error:nil];
        }
    }];
    
    return user;
}

- (BOOL)updateFollowingStatus:(NSArray *)userArray {
    if (!userArray.count) {
        return YES;
    }
    
    __block BOOL success = NO;
    [_dataBaseQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *newIds = [[userArray.rac_sequence map:^id(OCTUser *user) {
            return user.objectID;
        }].array componentsJoinedByString:@","];
        
        NSString *currentUserId = [OCTUser ad_currentUser].objectID;
        success = [db executeQuery:@"DELETE FROM userFollowingUser WHERE dstUserId in (?) and userId = ?", newIds, currentUserId];
        if (!success) {
            return;
        }
        
        for (OCTUser *user in userArray) {
            success = [db executeUpdate:@"REPLACE INTO userFollowingUser (userId, dstUserId) VALUES(?,?)", currentUserId, user.objectID];
            if (!success) {
                return;
            }
        }
    }];
    
    return success;
}

- (BOOL)updateFollowerStatus:(NSArray *)userArray {
    if (!userArray.count) {
        return YES;
    }
    
    __block BOOL success = NO;
    [_dataBaseQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *newIds = [[userArray.rac_sequence map:^id(OCTUser *user) {
            return user.objectID;
        }].array componentsJoinedByString:@","];
        
        NSString *currentUserId = [OCTUser ad_currentUser].objectID;
        success = [db executeQuery:@"DELETE FROM userFollowingUser WHERE userId in (?) and dstUserId = ?", newIds, currentUserId];
        if (!success) {
            return;
        }
        
        for (OCTUser *user in userArray) {
            success = [db executeUpdate:@"REPLACE INTO userFollowingUser (userId, dstUserId) VALUES(?,?)", user.objectID, currentUserId];
            if (!success) {
                return;
            }
        }
    }];
    
    return success;
}

- (BOOL)followeUser:(OCTUser *)user {
    if (!user) {
        return YES;
    }
    
    __block BOOL success = NO;
    [_dataBaseQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
       
        OCTUser *currentUser = [OCTUser ad_currentUser];
        success = [db executeUpdate:@"REPLACE INTO userFollowingUser (userId, dstUserId) VALUES(?,?)", currentUser.objectID, user.objectID];
        if (!success) {
            return;
        }
        
        success = [db executeUpdate:@"UPDATE user SET following = following + 1 WHERE id = ?", currentUser.objectID];
        if (!success) {
            return;
        }
        
        success = [db executeUpdate:@"UPDATE user SET followers = followers + 1 WHERE id = ?", user.objectID];
        if (!success) {
            return;
        }
        
        user.followingStatus = ADFollowStatusYes;
        [user ad_increaseFollowers];
        [currentUser ad_increaseFollowing];
    }];
    
    return success;
}

- (BOOL)unfollowUser:(OCTUser *)user {
    if (!user) {
        return YES;
    }
    
    __block BOOL success = NO;
    [_dataBaseQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        OCTUser *currentUser = [OCTUser ad_currentUser];
        success = [db executeUpdate:@"DELETE FROM userFollowingUser WHERE userId = ? AND dstUserId = ?", currentUser.objectID, user.objectID];
        if (!success) {
            return;
        }
        
        if (user.followers > 0) {
            success = [db executeUpdate:@"UPDATE user SET followers = followers - 1 WHERE id = ?", user.objectID];
        }
        if (!success) {
            return;
        }
        
        if (currentUser.following > 0) {
            success = [db executeUpdate:@"UPDATE user SET following = following - 1 WHERE id = ?", currentUser.objectID];
        }
        
        user.followingStatus = ADFollowStatusNo;
        [user ad_decreaseFollowers];
        [currentUser ad_decreaseFollowing];
    }];
    
    return success;
}

@end
