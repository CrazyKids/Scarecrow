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

+ (NSArray *)ad_fetchRepos {
    return [[self database]fetchRepos];
}

+ (NSArray *)ad_fetchPublicReposWithPage:(int)page pageStep:(int)pageStep {
    return [[self database]fetchPublicReposWithPage:page pageStep:pageStep];
}

- (void)setStarStatus:(ADReposStarStatus)starStatus {
    objc_setAssociatedObject(self, @selector(starStatus), @(starStatus), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (ADReposStarStatus)starStatus {
    return [objc_getAssociatedObject(self, _cmd) integerValue];
}

@end
