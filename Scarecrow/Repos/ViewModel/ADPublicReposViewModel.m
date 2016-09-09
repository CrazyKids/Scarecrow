//
//  ADPublicReposViewModel.m
//  Scarecrow
//
//  Created by duanhongjin on 16/9/8.
//  Copyright © 2016年 duanhongjin. All rights reserved.
//

#import "ADPublicReposViewModel.h"
#import "OCTRepository+Persistence.h"

@implementation ADPublicReposViewModel

- (NSArray *)fetchLocalData {
    if (self.isCurrentUser) {
        return [OCTRepository ad_fetchPublicReposWithPage:self.page pageStep:self.pageStep];
    }
    return nil;
}

- (RACSignal *)fetchRemoteDataSignalWithPage:(int)page {
    OCTClient *client = [ADPlatformManager sharedInstance].client;
    
    @weakify(self);
    return [[[[client fetchPublicRepositoriesForUser:self.user offset:[self offsetForPage:page] perPage:self.pageStep]take:self.pageStep]collect]map:^id(NSArray *reposArray) {
        @strongify(self);
        if (page != 1) {
            reposArray = @[(self.reposArray ?: @[]).rac_sequence, reposArray.rac_sequence].rac_sequence.flatten.array;
        }
        return reposArray;
    }];
}

@end
