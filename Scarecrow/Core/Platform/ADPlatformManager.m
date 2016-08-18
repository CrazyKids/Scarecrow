//
//  ADPlatformManager.m
//  Scarecrow
//
//  Created by duanhongjin on 7/8/16.
//  Copyright © 2016 duanhongjin. All rights reserved.
//

#import "ADPlatformManager.h"
#import "ADViewController.h"

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

- (ADViewController *)viewControllerWithViewModel:(ADViewModel *)viewModel {
    NSString *vmClassString = NSStringFromClass(viewModel.class);
    NSString *vcClassString = self.viewControllerMap[vmClassString];
    
    NSParameterAssert(vmClassString);
    
    Class vcClass = NSClassFromString(vcClassString);
    ADViewController *vc = [vcClass viewController];
    
    viewModel.ownerVC = vc;
    [vc initializeWithViewMode:viewModel];
    
    return vc;
}

- (NSDictionary *)viewControllerMap {
    return @{
             @"ADOauthViewModel" : @"ADOauthViewController",
             @"ADWebViewModel" : @"ADWebViewController",
             @"ADProfileViewModel" : @"ADProfileViewController",
             @"ADUserInfoViewModel" : @"ADUserInfoViewController",
             };
}

@end
