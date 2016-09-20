//
//  ADQRCodeModel.m
//  Scarecrow
//
//  Created by Victor Zhang on 9/16/16.
//  Copyright © 2016 duanhongjin. All rights reserved.
//

#import "ADQRCodeViewModel.h"
#import "OCTUser+Persistence.h"

@implementation ADQRCodeViewModel

- (instancetype)initWithParam:(NSDictionary *)param {
    self = [super initWithParam:param];
    if (self) {
        self.user = param[@"user"] ?: [OCTUser ad_currentUser];
    }
    return self;
}

- (void)initialize {
    [super initialize];
    
    self.title = @"My QR Code";
}


@end
