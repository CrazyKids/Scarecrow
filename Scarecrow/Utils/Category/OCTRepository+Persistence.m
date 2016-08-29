//
//  OCTRepository+Persistence.m
//  Scarecrow
//
//  Created by duanhongjin on 16/8/29.
//  Copyright © 2016年 duanhongjin. All rights reserved.
//

#import "OCTRepository+Persistence.h"
#import "ADDataBaseManager.h"

@implementation OCTRepository (Persistence)

+ (ADDataBase *)database {
    return [ADPlatformManager sharedInstance].dataBaseManager.dataBase;
}

- (BOOL)ad_update {
    return [[[self class]database]updateRepos:self];
}

- (NSArray<__kindof OCTRepository*> *)fetchRepos {
    return [[[self class]database]fetchRepos];
}

@end
