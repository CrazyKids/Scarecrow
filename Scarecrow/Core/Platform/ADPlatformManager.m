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
#import "SAMKeychain+Scarecrow.h"
#import "OCTUser+Persistence.h"
#import "ADViewModelService.h"

NSString *const kTrendingLanguageCacheKey = @"kTrendingLanguageCacheKey";
NSString *const kExploreTrendingRepositoriesCacheKey = @"kExploreTrendingRepositoriesCacheKey";
NSString *const kPopularUsersLanguageCacheKey = @"kPopularUsersLanguageCacheKey";
NSString *const kPopularUserCountryCacheKey = @"kPopularUserCountryCacheKey";
NSString *const kPopularReposLanguageCacheKey = @"kPopularReposLanguageCacheKey";

@interface ADPlatformManager ()

@property (strong, nonatomic) ADDataBaseManager *dataBaseManager;

@property (strong, nonatomic) YYCache *cacheMgr;
@property (strong, nonatomic) ADViewModelService *service;

@end

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
        NSString *rawLogin = [SAMKeychain username];
        if (!_dataBaseManager && rawLogin.length) {
            _dataBaseManager = [[ADDataBaseManager alloc]initWithRawLogin:rawLogin];
        }
        
        return _dataBaseManager;
    }
}

- (YYCache *)cacheMgr {
    if (!_cacheMgr) {
        NSString *login = [OCTUser ad_currentUser].login;
        _cacheMgr = [YYCache cacheWithName:login];
    }
    return _cacheMgr;
}

- (ADViewModelService *)service {
    if (!_service) {
        _service = [ADViewModelService new];
    }
    return _service;
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
             @"ADLocalWebViewModel" : @"ADLocalWebViewController",
             @"ADProfileViewModel" : @"ADProfileViewController",
             @"ADUserInfoViewModel" : @"ADUserInfoViewController",
             @"ADSetttingsViewModel" : @"ADSettingsViewController",
             @"ADFollowingViewModel" : @"ADFollowingViewController",
             @"ADFollowersViewModel" : @"ADFollowersViewController",
             @"ADReposViewModel" : @"ADReposViewController",
             @"ADPublicReposViewModel" : @"ADPublicReposViewController",
             @"ADStarredReposViewModel" : @"ADStarredReposViewController",
             @"ADPublicActivityViewModel" : @"ADPublicActivityViewController",
             @"ADReposDetailViewModel" : @"ADReposDetailViewController",
             @"ADCodeTreeViewModel" : @"ADCodeTreeViewController",
             @"ADReposInfoViewModel" : @"ADReposInfoViewController",
             @"ADReposSettingsViewModel" : @"ADReposSettingsViewController",
             @"ADQRCodeViewModel" : @"ADQRCodeViewerController",
             @"ADUserQRCodeViewModel" : @"ADQRCodeViewerController",
             @"ADReposQRCodeViewModel" : @"ADQRCodeViewerController",
             @"ADTrendingViewModel" : @"ADTrendingViewController",
             @"ADPopularUsersViewModel" : @"ADPopularUsersViewController",
             @"ADPopularReposViewModel" : @"ADPopularReposViewController",
             @"ADShowCasesViewModel" : @"ADShowCasesViewController",
             @"ADSearchViewModel" : @"ADSearchViewController",
             @"ADBrowseViewModel" : @"ADBrowseViewController",
             @"ADTrendingReposViewModel" : @"ADTrendingReposViewController",
             @"ADLanguageViewModel" : @"ADLanguageViewController",
             @"ADCountriesViewModel" : @"ADCountriesViewController",
             };
}

@end
