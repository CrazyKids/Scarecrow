//
//  ADUserListItemViewModel.m
//  Scarecrow
//
//  Created by duanhongjin on 8/20/16.
//  Copyright © 2016 duanhongjin. All rights reserved.
//

#import "ADUserListItemViewModel.h"

@interface ADUserListItemViewModel ()

@property (copy, nonatomic) NSURL *avatarURL;
@property (copy, nonatomic) NSString *login;

@end

@implementation ADUserListItemViewModel

- (instancetype)initWithUser:(OCTUser *)user {
    self = [super init];
    if (self) {
        self.user = user;
        self.avatarURL = user.avatarURL;
        self.login = user.login;
    }
    return self;
}

@end
