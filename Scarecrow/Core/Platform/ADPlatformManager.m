//
//  ADPlatformManager.m
//  Scarecrow
//
//  Created by duanhongjin on 7/8/16.
//  Copyright © 2016 duanhongjin. All rights reserved.
//

#import "ADPlatformManager.h"
#import "ADViewController.h"
#import "ADDataBaseManager.h"
#import "SSKeychain+Scarecrow.h"

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

- (ADDataBaseManager *)dataBaseManager {
    @synchronized (self) {
        NSString *rawLogin = [SSKeychain username];
        if (!_dataBaseManager && rawLogin.length) {
            _dataBaseManager = [[ADDataBaseManager alloc]initWithRawLogin:rawLogin];
        }
        
        return _dataBaseManager;
    }
}

- (ADViewController *)viewControllerWithViewModel:(ADViewModel *)viewModel {
    NSString *vmClassString = NSStringFromClass(viewModel.class);
    NSString *vcClassString = self.viewControllerMap[vmClassString];
    
    NSParameterAssert(vmClassString);
    
    Class vcClass = NSClassFromString(vcClassString);
    ADViewController *vc = [vcClass viewController];
    vc.hidesBottomBarWhenPushed = YES;
    
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
             @"ADSetttingsViewModel" : @"ADSettingsViewController",
             @"ADFollowingViewModel" : @"ADFollowingViewController",
             @"ADFollowersViewModel" : @"ADFollowersViewController",
             @"ADReposViewModel" : @"ADReposViewController",
             @"ADPublicReposViewModel" : @"ADPublicReposViewController",
             @"ADStarredReposViewModel" : @"ADStarredReposViewController",
             };
}

@end
