//
//  ADQRCodeModel.m
//  Scarecrow
//
//  Created by Victor Zhang on 9/16/16.
//  Copyright © 2016 duanhongjin. All rights reserved.
//

#import "ADQRCodeViewModel.h"
#import "OCTUser+Persistence.h"

@interface ADQRCodeViewModel()

@property (strong, nonatomic) OCTUser *user;

@end

@implementation ADQRCodeViewModel

- (instancetype)initWithParam:(NSDictionary *)param {
    self = [super initWithParam:param];
    if (self) {
        self.user = param[@"user"] ?: [OCTUser ad_currentUser];
    }
    return self;
}

- (BOOL)isCurrentUser {
    return [self.user.objectID isEqualToString:[OCTUser ad_currentUser].objectID];
}

- (void)initialize {
    [super initialize];


}

@end
