//
//  ADSearchViewModel.m
//  Scarecrow
//
//  Created by duanhongjin on 2017/5/1.
//  Copyright © 2017年 duanhongjin. All rights reserved.
//

#import "ADSearchViewModel.h"

@implementation ADSearchViewModel

- (instancetype)initWithParam:(NSDictionary *)param {
    self = [super initWithParam:param];
    if (self) {
        NSString *searchType = param[@"searchType"];
        if ([searchType isEqualToString:@"users"]) {
            
        } else if ([searchType isEqualToString:@"repositories"]) {
            
        }
    }
    return self;
}

@end
