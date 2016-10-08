//
//  ADStarredReposViewModel.m
//  Scarecrow
//
//  Created by duanhongjin on 9/9/16.
//  Copyright © 2016 duanhongjin. All rights reserved.
//

#import "ADStarredReposViewModel.h"
#import "OCTRepository+Persistence.h"

@implementation ADStarredReposViewModel

- (void)updateRepos:(NSArray *)reposArray {
    if (!self.isCurrentUser) {
        return;
    }
    
    [OCTRepository ad_update:reposArray];
    [OCTRepository ad_updateStarStatus:reposArray];
}

- (NSArray *)fetchLocalData {
    if (self.isCurrentUser) {
        return [OCTRepository ad_fetchStarredReposWithPage:self.page pageStep:self.pageStep];
    }
    
    return nil;
}

- (RACSignal *)fetchRemoteDataSignalWithPage:(int)page {
    OCTClient * client = [ADPlatformManager sharedInstance].client;
    
    if (self.isCurrentUser) {
        return [[[client fetchUserStarredRepositories]collect]map:^id(NSArray *reposArray) {
            for (OCTRepository *repos in reposArray) {
                repos.starStatus = ADReposStarStatusYes;
            }
            
            return reposArray;
        }];
    }
    
    return [[[[[client fetchStarredRepositoriesForUser:self.user offset:[self offsetForPage:self.page] perPage:self.pageStep]take:self.pageStep]collect]doNext:^(NSArray *reposArray) {
        if (self.isCurrentUser) {
            for (OCTRepository *repos in reposArray) {
                repos.starStatus = ADReposStarStatusYes;
            }
        }
    }]map:^id(NSArray *reposArray) {
        if (page != 1) {
            reposArray = @[(self.reposArray ?: @[]).rac_sequence, reposArray.rac_sequence].rac_sequence.flatten.array;
        }
        
        return reposArray;
    }];
}

@end
