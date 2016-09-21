//
//  ADQRCodeCompletion.m
//  Scarecrow
//
//  Created by duanhongjin on 16/9/22.
//  Copyright © 2016年 duanhongjin. All rights reserved.
//

#import "ADQRCodeCompletion.h"
#import "ADWebViewModel.h"
#import "NSURL+Scarecrow.h"
#import "ADUserInfoViewModel.h"
#import "ADReposInfoViewModel.h"

@implementation ADQRCodeCompletion

- (void)performQRCodeCompletion:(__kindof UIViewController *)viewController stringValue:(NSString *)strValue removeTopAfterSuccess:(void(^)())success {
    NSURL *url = [NSURL URLWithString:strValue];
    if (url && success) {
        success();
    }
    
    [self parseURL:url ownerVC:viewController];
}

- (void)parseURL:(NSURL *)url ownerVC:(UIViewController *)ownerVC {
    if (!url) {
        return;
    }
    
    NSString *absoluteString = url.absoluteString;
    NSString *prefix = @"https://github.com/";
    
    // 不是github
    if (![absoluteString hasPrefix:prefix]) {
        [self gotoWebViewWithURL:url ownerVC:ownerVC];
        
        return;
    }
    
    // 这种既不是user，也不是repos，爷不管
    NSURLComponents *components = [NSURLComponents componentsWithURL:url resolvingAgainstBaseURL:NO];
    if (components.queryItems.count > 0) {
        [self gotoWebViewWithURL:url ownerVC:ownerVC];
        
        return;
    }
    
    NSRange range = [absoluteString rangeOfString:prefix];
    NSString *path = [absoluteString substringFromIndex:range.length];
    NSArray *array = [path componentsSeparatedByString:@"/"];
    
    // 什么鬼？不认识
    if (array.count > 2) {
        [self gotoWebViewWithURL:url ownerVC:ownerVC];
        
        return;
    }
    
    if (array.count == 1) {
        [self gotoUserInfo:path ownerVC:ownerVC];
        
        return;
    }
    
    [self gotoRepos:path ownerVC:ownerVC];
}

- (void)gotoWebViewWithURL:(NSURL *)url ownerVC:(UIViewController *)ownerVC {
    ADWebViewModel *webModel = [ADWebViewModel new];
    webModel.request = [NSURLRequest requestWithURL:url];
    
    ADViewController *vc = [[ADPlatformManager sharedInstance]viewControllerWithViewModel:webModel];
    if (!vc) {
        return;
    }
    
    [ownerVC.navigationController pushViewController:vc animated:YES];
}

- (void)gotoUserInfo:(NSString *)ownerLogin ownerVC:(UIViewController *)ownerVC {
    NSURL *url = [NSURL ad_userLink:ownerLogin];
    
    ADUserInfoViewModel *userInfoModel = [[ADUserInfoViewModel alloc]initWithParam:[url ad_dic]];
    
    ADViewController *vc = [[ADPlatformManager sharedInstance]viewControllerWithViewModel:userInfoModel];
    if (!vc) {
        return;
    }
    
    [ownerVC.navigationController pushViewController:vc animated:YES];
}

- (void)gotoRepos:(NSString *)path ownerVC:(UIViewController *)ownerVC {
    NSURL *url = [NSURL ad_reposLink:path referName:nil];
    
    ADReposInfoViewModel *reposViewModel = [[ADReposInfoViewModel alloc]initWithParam:[url ad_dic]];
    
    ADViewController *vc = [[ADPlatformManager sharedInstance]viewControllerWithViewModel:reposViewModel];
    if (!vc) {
        return;
    }
    
    [ownerVC.navigationController pushViewController:vc animated:YES];
}

@end
