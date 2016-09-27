//
//  ADPlatformManager.h
//  Scarecrow
//
//  Created by duanhongjin on 7/8/16.
//  Copyright © 2016 duanhongjin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ADViewController.h"
#import <YYKit/YYKit.h>

@class ADViewModel;
@class ADDataBaseManager;

@interface ADPlatformManager : NSObject

@property (strong, nonatomic) OCTClient *client;
@property (strong, nonatomic, readonly) ADDataBaseManager *dataBaseManager;

@property (strong, nonatomic, readonly) YYCache *cacheMgr;

+ (ADPlatformManager *)sharedInstance;

- (void)resetRootViewModel:(ADViewModel *)viewModel;

- (ADViewController *)viewControllerWithViewModel:(ADViewModel *)viewModel;

@end
