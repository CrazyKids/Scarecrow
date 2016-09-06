//
//  ADReposViewModel.h
//  Scarecrow
//
//  Created by duanhongjin on 16/8/30.
//  Copyright © 2016年 duanhongjin. All rights reserved.
//

#import "ADTableViewModel.h"

typedef NS_OPTIONS(NSInteger, ADReposOption) {
    ADReposOptionShowOwnerLogin = 1 << 0,
    ADReposOptionUpdate = 1 << 1,
};

@interface ADReposViewModel : ADTableViewModel

@property (strong, nonatomic, readonly) OCTUser *user;
@property (assign, nonatomic, readonly) BOOL isCurrentUser;
@property (strong, nonatomic, readonly) NSArray<OCTRepository *> *reposArray;

@property (assign, nonatomic, readonly) ADReposOption options;

- (void)updateRepos:(NSArray *)repos;
- (RACSignal *)dataSourceSignalWithRopse:(NSArray *)reposArray;

@end
