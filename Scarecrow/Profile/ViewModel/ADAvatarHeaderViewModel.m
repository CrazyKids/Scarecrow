//
//  ADAvatarHeaderViewModel.m
//  Scarecrow
//
//  Created by duanhongjin on 8/13/16.
//  Copyright © 2016 duanhongjin. All rights reserved.
//

#import "ADAvatarHeaderViewModel.h"

@interface ADAvatarHeaderViewModel ()

@property (strong, nonatomic) OCTUser *user;

@end

@implementation ADAvatarHeaderViewModel

- (instancetype)initWithUser:(OCTUser *)user {
    self = [super init];
    if (self) {
        self.user = user;
    }
    
    return self;
}

@end
