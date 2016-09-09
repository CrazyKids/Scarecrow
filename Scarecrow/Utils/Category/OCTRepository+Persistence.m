//
//  OCTRepository+Persistence.m
//  Scarecrow
//
//  Created by duanhongjin on 16/8/29.
//  Copyright © 2016年 duanhongjin. All rights reserved.
//

#import "OCTRepository+Persistence.h"
#import "ADDataBaseManager.h"
#import <objc/runtime.h>

@implementation OCTRepository (Persistence)

+ (ADDataBase *)database {
    return [ADPlatformManager sharedInstance].dataBaseManager.dataBase;
}

+ (NSArray *)ad_matchStarredStatus:(NSArray *)reposArray {
    if (!reposArray.count) {
        return reposArray;
    }
    
    NSArray *starredReposArray = [self ad_fetchStarredRepos];
    for (OCTRepository *repos in reposArray) {
        if (repos.starStatus != ADReposStarStatusUnknown) {
            continue;
        }
        
        repos.starStatus = ADReposStarStatusNo;
        for (OCTRepository *starredRepos in starredReposArray) {
            if ([repos.objectID isEqualToString:starredRepos.objectID]) {
                repos.starStatus = YES;
                break;
            }
        }
    }
    
    return reposArray;
}

+ (BOOL)ad_update:(NSArray *)reposArray {
    ADDataBase *database = [self database];
    for (OCTRepository *repos in reposArray) {
        if (![database updateRepos:repos]) {
            return NO;
        }
    }
    
    return YES;
}

+ (BOOL)ad_updateStarStatus:(NSArray *)reposArray {
    return [[self database]updateStarStatus:reposArray];
}

+ (NSArray *)ad_fetchRepos {
    return [[self database]fetchRepos];
}

+ (NSArray *)ad_fetchStarredRepos {
    return [[self database]fetchStarredRepos];
}

+ (NSArray *)ad_fetchPublicReposWithPage:(int)page pageStep:(int)pageStep {
    return [[self database]fetchPublicReposWithPage:page pageStep:pageStep];
}

+ (NSArray *)ad_fetchStarredReposWithPage:(int)page pageStep:(int)pageStep {
    return [[self database]fetchStarredReposWithPage:page pageStep:pageStep];
}

- (void)setStarStatus:(ADReposStarStatus)starStatus {
    objc_setAssociatedObject(self, @selector(starStatus), @(starStatus), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (ADReposStarStatus)starStatus {
    return [objc_getAssociatedObject(self, _cmd) integerValue];
}

@end
