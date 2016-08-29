//
//  ADReposViewModel.h
//  Scarecrow
//
//  Created by duanhongjin on 16/8/30.
//  Copyright © 2016年 duanhongjin. All rights reserved.
//

#import "ADTableViewModel.h"

@interface ADReposViewModel : ADTableViewModel

@property (strong, nonatomic, readonly) OCTUser *user;
@property (assign, nonatomic, readonly) BOOL isCurrentUser;
@property (strong, nonatomic, readonly) NSArray<OCTRepository *> *reposArray;

@end
