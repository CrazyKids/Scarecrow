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
#import "OCTUser+Persistence.h"
#import "SSKeychain+Scarecrow.h"

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
        OCTUser *user = [OCTUser ad_userWithRawLogin:[SSKeychain username] server:OCTServer.dotComServer];
        
        OCTClient *client = [OCTClient authenticatedClientWithUser:user token:[SSKeychain accessToken]];
        [ADPlatformManager sharedInstance].client = client;
        
        return [ADTabBarViewModel new];
    }
    
    return [ADLoginViewModel new];
}

- (void)showRootViewController {
    ADPlatformManager *platform = [ADPlatformManager sharedInstance];
    
    @weakify(self);
    [[platform rac_signalForSelector:@selector(resetRootViewModel:)]subscribeNext:^(RACTuple *tuple) {
        @strongify(self);

        NSString *name = @"";
        if ([tuple.first isKindOfClass:[ADLoginViewModel class]]) {
            name = @"login";
        } else {
            name = @"TabBar";
        }
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:name bundle:nil];
        UIViewController *rootVC = [storyboard instantiateInitialViewControllerWithViewModel:tuple.first];
        
        self.window.rootViewController = rootVC;
        [self.window makeKeyAndVisible];
    }];
}

@end
