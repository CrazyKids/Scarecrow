//
//  ADPlatformManager.m
//  Scarecrow
//
//  Created by duanhongjin on 7/8/16.
//  Copyright © 2016 duanhongjin. All rights reserved.
//

#import "ADPlatformManager.h"

@implementation ADPlatformManager

+ (ADPlatformManager *)sharedInstance {
    static dispatch_once_t onceToken;
    static ADPlatformManager *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [ADPlatformManager new];
    });
    
    return instance;
}

- (void)resetRootViewModel:(ADViewModel *)viewModel {
    
}

@end
