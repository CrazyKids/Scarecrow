//
//  ADReposViewModel.m
//  Scarecrow
//
//  Created by duanhongjin on 16/8/30.
//  Copyright © 2016年 duanhongjin. All rights reserved.
//

#import "ADReposViewModel.h"
#import "OCTUser+Persistence.h"

@interface ADReposViewModel ()

@property (strong, nonatomic) OCTUser *user;
@property (strong, nonatomic) NSArray<OCTRepository *> *reposArray;

@end

@implementation ADReposViewModel

- (instancetype)initWithParam:(NSDictionary *)param {
    self = [super initWithParam:param];
    if (self) {
        self.user = param[@"user"] ?: [OCTUser ad_currentUser];
    }
    return self;
}

- (BOOL)isCurrentUser {
    return [self.user.objectID isEqualToString:[OCTUser ad_currentUser].objectID];
}

- (void)initialize {
    [super initialize];
    
    
}

@end
