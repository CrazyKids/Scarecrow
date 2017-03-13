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
#import "SAMKeychain+Scarecrow.h"
#import "ADTabBarViewModel.h"
#import "OCTUser+Persistence.h"
#import "UIColor+Scarecrow.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    [self showRootViewController];
    ADViewModel *viewModel = [self createInitialViewModel];
    [[ADPlatformManager sharedInstance]resetRootViewModel:viewModel];
    
    [self configureAppearance];
    
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

- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(nullable UIWindow *)window  {
    UIViewController *presentedViewController = self.window.rootViewController;
    if ([presentedViewController shouldAutorotate]) {
        return presentedViewController.supportedInterfaceOrientations;
    }
    return UIInterfaceOrientationMaskPortrait;
}

- (ADViewModel *)createInitialViewModel {
    if (SAMKeychain.username.length && SAMKeychain.accessToken.length) {
        OCTUser *user = [OCTUser ad_userWithRawLogin:[SAMKeychain username] server:OCTServer.dotComServer];
        
        OCTClient *client = [OCTClient authenticatedClientWithUser:user token:[SAMKeychain accessToken]];
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

- (void)configureAppearance {
    id navAppearance = [UINavigationBar appearance];
    [navAppearance setBarTintColor:DEFAULT_RGB];
    [navAppearance setTintColor:[UIColor whiteColor]];
    [navAppearance setBarStyle:UIBarStyleBlack];
    [navAppearance setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
}

@end
