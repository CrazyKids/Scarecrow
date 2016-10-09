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

@interface OCTRepository (database)

- (NSDictionary *)ad_toDatabaseDic;
+ (OCTRepository *)ad_fromDatabaseDic:(NSDictionary *)dic;

@end

@implementation OCTRepository (database)

- (NSDictionary *)ad_toDatabaseDic {
    NSMutableDictionary *dic = [MTLJSONAdapter JSONDictionaryFromModel:self].mutableCopy;
    dic[@"owner_login"] = dic[@"owner"][@"login"];
    dic[@"owner_avatar_url"] = dic[@"owner"][@"avatar_url"];
    
    return dic;
}

+ (OCTRepository *)ad_fromDatabaseDic:(NSDictionary *)dic {
    NSMutableDictionary *reposDic = dic.mutableCopy;
    reposDic[@"owner"] = @{
                           @"login" : dic[@"owner_login"],
                           @"avatar_url" : dic[@"owner_avatar_url"],
                           };
    return [MTLJSONAdapter modelOfClass:[OCTRepository class] fromJSONDictionary:reposDic error:nil];
}

@end

#pragma mark - ADDataBase

@implementation ADDataBase

+ (NSArray *)tableCreateSQLSentences {
    NSArray *array = @[
                       // user table
                       @"CREATE TABLE IF NOT EXISTS user (id INTEGER PRIMARY KEY, rawLogin TEXT, login TEXT, name TEXT, bio TEXT, email TEXT, avatar_url TEXT, html_url TEXT, blog TEXT, company TEXT, location TEXT, collaborators INTEGER, public_repos INTEGER, owned_private_repos INTEGER, public_gists INTEGER, private_gists INTEGER, followers INTEGER, following INTEGER, disk_usage INTEGER)",
                       
                       @"CREATE TABLE IF NOT EXISTS repos (id INTEGER PRIMARY KEY, name TEXT, owner_login TEXT, owner_avatar_url TEXT, description TEXT, language TEXT, pushed_at TEXT, created_at TEXT, updated_at TEXT, clone_url TEXT, ssh_url TEXT, git_url TEXT, html_url TEXT, default_branch TEXT, private INTEGER, fork INTEGER, watchers_count INTEGER, forks_count INTEGER, stargazers_count INTEGER, open_issues_count INTEGER, subscribers_count INTEGER)",
                       
                       // 比较绕，是user（我）following user（other）
                       @"CREATE TABLE IF NOT EXISTS userFollowingUser (id INTEGER PRIMARY KEY autoincrement, userId INTEGER, dstUserId INTEGER)",
                       
                       @"CREATE TABLE IF NOT EXISTS userStarredRepos (id INTEGER PRIMARY KEY autoincrement, userId INTEGER, reposId INTEGER)",
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
    if (!user) {
        return YES;
    }
    __block BOOL success = NO;
    [_dataBaseQueue updateDatabase:^(FMDatabase *db) {
        success = [db executeUpdate:@"REPLACE INTO user(id, rawLogin, login, name, bio, email, avatar_url, html_url, blog, company, location, collaborators, public_repos, owned_private_repos, public_gists, private_gists, followers, following, disk_usage) VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)", user.objectID, user.rawLogin, user.login, user.name, user.bio, user.email, user.avatarURL, user.HTMLURL, user.blog, user.company, user.location, @(user.collaborators), @(user.publicRepoCount), @(user.privateRepoCount), @(user.publicGistCount), @(user.privateGistCount), @(user.followers), @(user.following), @(user.diskUsage)];
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
    [_dataBaseQueue updateDatabase:^(FMDatabase *db) {
        NSString *newIds = [[userArray.rac_sequence map:^id(OCTUser *user) {
            return user.objectID;
        }].array componentsJoinedByString:@","];
        
        NSString *currentUserId = [OCTUser ad_currentUser].objectID;
        success = [db executeUpdate:@"DELETE FROM userFollowingUser WHERE dstUserId NOT IN (?) and userId = ?", newIds, currentUserId];
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
    [_dataBaseQueue updateDatabase:^(FMDatabase *db) {
        NSString *newIds = [[userArray.rac_sequence map:^id(OCTUser *user) {
            return user.objectID;
        }].array componentsJoinedByString:@","];
        
        NSString *currentUserId = [OCTUser ad_currentUser].objectID;
        success = [db executeUpdate:@"DELETE FROM userFollowingUser WHERE userId NOT IN (?) and dstUserId = ?", newIds, currentUserId];
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
    [_dataBaseQueue updateDatabase:^(FMDatabase *db) {
       
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
    [_dataBaseQueue updateDatabase:^(FMDatabase *db) {
        
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

- (BOOL)updateRepos:(OCTRepository *)repos {
    if (!repos) {
        return YES;
    }
    
    __block BOOL success = NO;
    [_dataBaseQueue updateDatabase:^(FMDatabase *db) {
       NSString *sql = @"REPLACE INTO repos (id, name, owner_login, owner_avatar_url, description, language, pushed_at, created_at, updated_at, clone_url, ssh_url, git_url, html_url, default_branch, private, fork, watchers_count, forks_count, stargazers_count, open_issues_count, subscribers_count) VALUES (:id, :name, :owner_login, :owner_avatar_url, :description, :language, :pushed_at, :created_at, :updated_at, :clone_url, :ssh_url, :git_url, :html_url, :default_branch, :private, :fork, :watchers_count, :forks_count, :stargazers_count, :open_issues_count, :subscribers_count)";
        
        success = [db executeUpdate:sql withParameterDictionary:[repos ad_toDatabaseDic]];
    }];
    
    return success;
}

- (BOOL)updateStarStatus:(NSArray *)reposArray {
    if (!reposArray.count) {
        return YES;
    }
    
    __block BOOL success = YES;
    
    [_dataBaseQueue updateDatabase:^(FMDatabase *db) {
        NSString *newIDs = [[reposArray.rac_sequence map:^id(OCTRepository *repos) {
            return repos.objectID;
        }].array componentsJoinedByString:@","];
        
        NSString *currentUserId = [OCTUser ad_currentUser].objectID;
        success = [db executeUpdate:@"DELETE FROM userStarredRepos WHERE userId = ? AND reposId NOT IN (?)", currentUserId, newIDs];
        if (!success) {
            return;
        }
        
        for (OCTRepository *repos in reposArray) {
            success = [db executeUpdate:@"REPLACE INTO userStarredRepos (userId, reposId) VALUES (?, ?)", currentUserId, repos.objectID];
            if (!success) {
                return;
            }
        }
    }];
    
    return success;
}

- (NSArray *)fetchFollowingWithPage:(int)page pageStep:(int)pageStep {
    __block NSMutableArray *array = [NSMutableArray new];
    
    [_dataBaseQueue queryInDatabase:^(FMDatabase *db) {
        FMResultSet *rs = nil;
        
        @onExit {
            [rs close];
        };
        
        NSString *currentUserId = [OCTUser ad_currentUser].objectID;
        
        int limit = page * pageStep;
        if (limit) {
            rs = [db executeQuery:@"SELECT * FROM userFollowingUser ufu, user u WHERE ufu.userId = ? AND ufu.dstUserId = u.id ORDER BY u.id LIMIT ?", currentUserId, @(limit)];
        } else {
            rs = [db executeQuery:@"SELECT * FROM userFollowingUser ufu, user u WHERE ufu.userId = ? AND ufu.dstUserId = u.id ORDER BY u.id", currentUserId];
        }
        
        while ([rs next]) {
            OCTUser *user = [MTLJSONAdapter modelOfClass:[OCTUser class] fromJSONDictionary:rs.resultDictionary error:nil];
            user.followingStatus = ADFollowStatusYes;
            
            [array addObject:user];
        }
    }];
    
    return array;
}

- (NSArray *)fetchFollowersWithPage:(int)page pageStep:(int)pageStep {
    __block NSMutableArray *array = [NSMutableArray new];
    
    [_dataBaseQueue queryInDatabase:^(FMDatabase *db) {
        FMResultSet *rs = nil;
        
        @onExit {
            [rs close];
        };
        
        NSString *currentUserId = [OCTUser ad_currentUser].objectID;
        
        int limit = page * pageStep;
        if (limit) {
            rs = [db executeQuery:@"SELECT * FROM userFollowingUser ufu, user u WHERE ufu.dstUserId = ? AND ufu.userId = u.id ORDER BY u.id LIMIT ?", currentUserId, @(limit)];
        } else {
            rs = [db executeQuery:@"SELECT * FROM userFollowingUser ufu, user u WHERE ufu.dstUserId = ? AND ufu.userId = u.id ORDER BY u.id", currentUserId];
        }
        
        while ([rs next]) {
            OCTUser *user = [MTLJSONAdapter modelOfClass:[OCTUser class] fromJSONDictionary:rs.resultDictionary error:nil];
            user.followingStatus = ADFollowStatusYes;
            
            [array addObject:user];
        }
    }];
    
    return array;
}

- (NSArray *)fetchRepos {
    __block NSMutableArray *reposArray = [NSMutableArray new];
    [_dataBaseQueue queryInDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:@"SELECT * FROM repos WHERE owner_login = ? ORDER BY LOWER(name)", [OCTUser ad_currentUser].login];
        
        @onExit {
            [rs close];
        };
        
        while ([rs next]) {
            OCTRepository *repos = [OCTRepository ad_fromDatabaseDic:rs.resultDictionary];
            if (repos) {
                [reposArray addObject:repos];
            }
        }
    }];
    
    return reposArray;
}

- (NSArray *)fetchStarredRepos {
    __block NSMutableArray *reposArray = [NSMutableArray new];
    
    [_dataBaseQueue queryInDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:@"SELECT * FROM userStarredRepos u, repos r WHERE u.userId = ? AND u.reposId = r.id ORDER BY LOWER(name)", [OCTUser ad_currentUser].objectID];
        
        @onExit {
            [rs close];
        };
        
        while ([rs next]) {
            OCTRepository *repos = [OCTRepository ad_fromDatabaseDic:rs.resultDictionary];
            if (repos) {
                [reposArray addObject:repos];
            }
        }
    }];
    
    return reposArray;
}

- (NSArray *)fetchPublicReposWithPage:(int)page pageStep:(int)pageStep {
    __block NSMutableArray *reposArray = [NSMutableArray new];
    [_dataBaseQueue queryInDatabase:^(FMDatabase *db) {
        FMResultSet *rs = nil;
        
        @onExit {
            [rs close];
        };
        
        int limit = page * pageStep;
        if (limit) {
            rs = [db executeQuery:@"SELECT * FROM repos WHERE owner_login = ? AND private = 0 ORDER BY LOWER(name) LIMIT ?", [OCTUser ad_currentUser].login, @(limit)];
        } else {
            rs = [db executeQuery:@"SELECT * FROM repos WHERE owner_login = ? AND private = 0 ORDER BY LOWER(name)", [OCTUser ad_currentUser].login];
        }
        
        while ([rs next]) {
            OCTRepository *repos = [OCTRepository ad_fromDatabaseDic:rs.resultDictionary];
            if (repos) {
                [reposArray addObject:repos];
            }
        }
    }];
    
    return reposArray;
}

- (NSArray *)fetchStarredReposWithPage:(int)page pageStep:(int)pageStep {
    __block NSMutableArray *reposArray = [NSMutableArray new];
    
    [_dataBaseQueue queryInDatabase:^(FMDatabase *db) {
        FMResultSet *rs = nil;
        
        @onExit {
            [rs close];
        };
        
        NSString *currentUserId = [OCTUser ad_currentUser].objectID;
        
        int limit = page * pageStep;
        if (limit) {
            rs = [db executeQuery:@"SELECT * FROM userStarredRepos u, repos r WHERE u.userId = ? AND u.reposId = r.id ORDER BY LOWER(name) LIMIT ?", currentUserId, @(limit)];
        } else {
            rs = [db executeQuery:@"SELECT * FROM userStarredRepos u, repos r WHERE u.userId = ? AND u.reposId = r.id ORDER BY LOWER(name)", currentUserId];
        }
        
        while ([rs next]) {
            OCTRepository *repos = [OCTRepository ad_fromDatabaseDic:rs.resultDictionary];
            if (repos) {
                [reposArray addObject:repos];
            }
        }
    }];
    
    return reposArray;
}

- (OCTRepository *)fetchFullRepos:(OCTRepository *)repos {
    __block OCTRepository *fullRepos = nil;
    
    [_dataBaseQueue queryInDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:@"SELECT * FROM repos WHERE name = ? AND owner_login = ?", repos.name, repos.ownerLogin];
        @onExit {
            [rs close];
        };
        
        if ([rs next]) {
            fullRepos = [OCTRepository ad_fromDatabaseDic:rs.resultDictionary];
        }
    }];
    
    return fullRepos;
}

@end
