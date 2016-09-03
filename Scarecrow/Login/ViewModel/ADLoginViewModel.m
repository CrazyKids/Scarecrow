//
//  ADLoginViewModel.m
//  Scarecrow
//
//  Created by duanhongjin on 16/7/7.
//  Copyright © 2016年 duanhongjin. All rights reserved.
//

#import "ADLoginViewModel.h"
#import "SSKeychain+Scarecrow.h"
#import "ADTabBarViewModel.h"
#import "ADPlatformManager.h"
#import "OCTUser+Persistence.h"
#import "ADOauthViewModel.h"

@interface ADLoginViewModel ()

@property (strong, nonatomic) RACCommand *loginCommand;
@property (strong, nonatomic) RACCommand *exchangeTokenCommand;

@end

@implementation ADLoginViewModel
- (void)initialize {
    [super initialize];
    
    void (^loginSuccess)(OCTClient *) = ^(OCTClient *client) {
        [ADPlatformManager sharedInstance].client = client;
        
        SSKeychain.username = client.user.rawLogin;
        SSKeychain.accessToken = client.token;
        
        [client.user ad_update];
        
        ADTabBarViewModel *tabBarViewModel = [ADTabBarViewModel new];
        dispatch_async(dispatch_get_main_queue(), ^{
            [[ADPlatformManager sharedInstance]resetRootViewModel:tabBarViewModel];
        });
    };
 
    [OCTClient setClientID:github_client_id clientSecret:github_client_secret];
    
    @weakify(self);
    self.loginCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);

        ADOauthViewModel *viewModel = [ADOauthViewModel new];
        @weakify(viewModel);
        viewModel.callback = ^(NSString *code) {
            @strongify(viewModel);
            [viewModel.ownerVC.navigationController popViewControllerAnimated:YES];
            [self.exchangeTokenCommand execute:code];
        };
        
        ADViewController *vc = [[ADPlatformManager sharedInstance]viewControllerWithViewModel:viewModel];
        [self.ownerVC.navigationController pushViewController:vc animated:YES];
        
        return [RACSignal empty];
    }];
    
    self.exchangeTokenCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(NSString *code) {
        OCTClient *client = [[OCTClient alloc]initWithServer:[OCTServer dotComServer]];
        
        return [[[[[client exchangeTokenWithCode:code]doNext:^(OCTAccessToken *accessToken) {
            [client setValue:accessToken.token forKey:@"token"];
        }]flattenMap:^RACStream *(id value) {
            return [[client fetchUserInfo]doNext:^(OCTUser *user) {
                NSMutableDictionary *mutableDictionary = [[NSMutableDictionary alloc] init];
                [mutableDictionary addEntriesFromDictionary:user.dictionaryValue];
                
                if (user.rawLogin.length == 0) {
                    mutableDictionary[@keypath(user.rawLogin)] = user.login;
                }
                user = [OCTUser modelWithDictionary:mutableDictionary error:NULL];
                [client setValue:user forKey:@"user"];
            }];
        }]mapReplace:client]doNext:loginSuccess];
    }];
}

@end
