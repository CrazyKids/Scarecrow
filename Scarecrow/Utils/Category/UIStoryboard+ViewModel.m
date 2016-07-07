//
//  UIStoryboard+ViewModel.m
//  Scarecrow
//
//  Created by duanhongjin on 7/8/16.
//  Copyright © 2016 duanhongjin. All rights reserved.
//

#import "UIStoryboard+ViewModel.h"
#import "ADViewController.h"
#import "ADTabBarController.h"

@implementation UIStoryboard (ViewModel)

- (__kindof UIViewController *)instantiateViewControllerWithIdentifier:(NSString *)identifier viewModel:(ADViewModel *)viewModel {
    UIViewController *vc = [self instantiateViewControllerWithIdentifier:identifier];
    
    NSParameterAssert([vc isKindOfClass:[ADViewController class]]);
    
    ADViewController *viewController = (ADViewController *)vc;
    SEL selector = NSSelectorFromString(@"initializeWithViewMode:");
    if ([viewController respondsToSelector:selector]) {
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [viewController performSelector:selector withObject:viewModel];
    }
    
    return vc;
}

- (__kindof UIViewController *)instantiateInitialViewControllerWithViewModel:(ADViewModel *)viewModel {
    UIViewController *vc = [self instantiateInitialViewController];
    
    NSParameterAssert([vc isKindOfClass:[ADTabBarController class]]);
    
    ADTabBarController *viewController = (ADTabBarController *)vc;
    SEL selector = NSSelectorFromString(@"initializeWithViewMode:");
    if ([viewController respondsToSelector:selector]) {
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [viewController performSelector:selector withObject:viewModel];
    }
    
    return vc;
}

@end
