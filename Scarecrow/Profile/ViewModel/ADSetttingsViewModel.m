//
//  ADSetttingsViewModel.m
//  Scarecrow
//
//  Created by duanhongjin on 8/19/16.
//  Copyright © 2016 duanhongjin. All rights reserved.
//

#import "ADSetttingsViewModel.h"
#import "SAMKeychain+Scarecrow.h"
#import "ADLoginViewModel.h"

@interface ADSetttingsViewModel ()

@property (strong, nonatomic) RACCommand *logoutCommand;

@end

@implementation ADSetttingsViewModel

- (void)initialize {
    [super initialize];
    
    self.title = @"Settings";
    self.bShouldPullToRefresh = NO;
    
    self.logoutCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        [SAMKeychain deleteAccessToken];
        
        //删除目录缓存
        NSString *libStr = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject];
        NSString *cookies = [libStr stringByAppendingPathComponent:@"/Cookies"];
        NSString *webkit = [libStr stringByAppendingPathComponent:@"/WebKit"];
        NSFileManager *filemng = [NSFileManager defaultManager];
        [filemng removeItemAtPath:cookies error:nil];
        [filemng removeItemAtPath:webkit error:nil];
        
        ADLoginViewModel *viewModel = [ADLoginViewModel new];
        [[ADPlatformManager sharedInstance] resetRootViewModel:viewModel];
        
        return [RACSignal empty];
    }];
    
    self.didSelectCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        return [RACSignal empty];
    }];
}

@end
