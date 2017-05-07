//
//  ADViewModelService.m
//  Scarecrow
//
//  Created by duanhongjin on 24/03/2017.
//  Copyright © 2017 duanhongjin. All rights reserved.
//

#import "ADViewModelService.h"
#import "ADRepositoryService.h"

@implementation ADViewModelService

- (instancetype)init {
    self = [super init];
    if (self) {
        _reposService = [ADRepositoryService new];
    }
    return self;
}

@end
