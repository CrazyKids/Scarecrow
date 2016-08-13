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
    
    viewModel.ownerVC = vc;
    [self setViewModel:viewModel toVC:vc];
    
    return vc;
}

- (__kindof UIViewController *)instantiateInitialViewControllerWithViewModel:(ADViewModel *)viewModel {
    UIViewController *vc = [self instantiateInitialViewController];
    
    NSParameterAssert([vc isKindOfClass:[ADTabBarController class]] || [vc isKindOfClass:[UINavigationController class]]);
    viewModel.ownerVC = vc;
    [self setViewModel:viewModel toVC:vc];
    
    if ([vc isKindOfClass:[UINavigationController class]]) {
        UIViewController *top = ((UINavigationController *)vc).topViewController;
        viewModel.ownerVC = top;
        [self setViewModel:viewModel toVC:top];
    }
    
    return vc;
}

- (void)setViewModel:(ADViewModel *)viewModel toVC:(UIViewController *)vc {
    SEL selector = NSSelectorFromString(@"initializeWithViewMode:");
    if ([vc respondsToSelector:selector]) {
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [vc performSelector:selector withObject:viewModel];
    }
}

@end
