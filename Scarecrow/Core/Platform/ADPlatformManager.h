//
//  ADPlatformManager.h
//  Scarecrow
//
//  Created by duanhongjin on 7/8/16.
//  Copyright © 2016 duanhongjin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ADViewController.h"

@class ADViewModel;

@interface ADPlatformManager : NSObject

@property (strong, nonatomic) OCTClient *client;

+ (ADPlatformManager *)sharedInstance;

- (void)resetRootViewModel:(ADViewModel *)viewModel;

- (ADViewController *)viewControllerWithViewModel:(ADViewModel *)viewModel;

@end
