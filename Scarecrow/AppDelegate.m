//
//  AppDelegate.m
//  Scarecrow
//
//  Created by duanhongjin on 7/7/16.
//  Copyright © 2016 duanhongjin. All rights reserved.
//

#import "AppDelegate.h"
#import "ADViewController.h"
#import "ADLoginViewModel.h"
#import "SSKeychain+Scarecrow.h"
#import "ADTabBarViewModel.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    [self showRootViewController];
    ADViewModel *viewModel = [self createInitialViewModel];
    [[ADPlatformManager sharedInstance]resetRootViewModel:viewModel];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {

}

- (void)applicationDidEnterBackground:(UIApplication *)application {

}

- (void)applicationWillEnterForeground:(UIApplication *)application {

}

- (void)applicationDidBecomeActive:(UIApplication *)application {

}

- (void)applicationWillTerminate:(UIApplication *)application {
    
}

- (ADViewModel *)createInitialViewModel {
    if (SSKeychain.username.length && SSKeychain.accessToken.length) {
        return [ADTabBarViewModel new];
    }
    
    return [ADLoginViewModel new];
}

- (void)showRootViewController {
    ADPlatformManager *platform = [ADPlatformManager sharedInstance];
    
    @weakify(self)
    [[platform rac_signalForSelector:@selector(resetRootViewModel:)]subscribeNext:^(RACTuple *tuple) {
        @strongify(self)
        
        UIViewController *rootVC = nil;
        if ([tuple.first isKindOfClass:[ADLoginViewModel class]]) {
            UIStoryboard *stroyboard = [UIStoryboard storyboardWithName:@"login" bundle:nil];
            rootVC = [stroyboard instantiateViewControllerWithIdentifier:@"login" viewModel:tuple.first];
        } else {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"TabBar" bundle:nil];
            rootVC = [storyboard instantiateInitialViewControllerWithViewModel:tuple.first];
        }
        
        self.window.rootViewController = rootVC;
        [self.window makeKeyAndVisible];
    }];
}

@end
