//
//  OCTRepository+Persistence.h
//  Scarecrow
//
//  Created by duanhongjin on 16/8/29.
//  Copyright © 2016年 duanhongjin. All rights reserved.
//

#import <OctoKit/OctoKit.h>

@interface OCTRepository (Persistence)

- (BOOL)ad_update;
- (NSArray<__kindof OCTRepository*> *)fetchRepos;

@end
