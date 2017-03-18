//
//  YYCache+Scarecrow.m
//  Scarecrow
//
//  Created by duanhongjin on 2017/3/23.
//  Copyright © 2017年 duanhongjin. All rights reserved.
//

#import "YYCache+Scarecrow.h"
#import "OCTUser+Persistence.h"

NSString *const kTrendingLanguageCacheKey = @"kTrendingLanguageCacheKey";

@implementation YYCache (Scarecrow)

+ (instancetype)sharedInstance {
    static YYCache *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *cacheName = [OCTUser ad_currentUser].login;
        sharedInstance = [YYCache cacheWithName:cacheName];
    });
    
    return sharedInstance;
}

@end
