//
//  ADReposItemViewModel.h
//  Scarecrow
//
//  Created by duanhongjin on 16/9/7.
//  Copyright © 2016年 duanhongjin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ADReposViewModel.h"

@interface ADReposItemViewModel : NSObject

@property (strong, nonatomic, readonly) OCTRepository *repos;

@property (copy, nonatomic, readonly) NSAttributedString *name;
@property (copy, nonatomic, readonly) NSAttributedString *reposDescription;
@property (copy, nonatomic, readonly) NSString *udpateTime;
@property (copy, nonatomic, readonly) NSString *language;

@property (assign, nonatomic, readonly) CGFloat height;

- (instancetype)initWithRepos:(OCTRepository *)repos currentUser:(BOOL)currentUser;

@end
