//
//  ADOauthViewModel.m
//  Scarecrow
//
//  Created by duanhongjin on 8/12/16.
//  Copyright © 2016 duanhongjin. All rights reserved.
//

#import "ADOauthViewModel.h"

@implementation ADOauthViewModel

- (void)initialize {
    [super initialize];
    
    CFUUIDRef UUID = CFUUIDCreate(NULL);
    self.UUID = CFBridgingRelease(CFUUIDCreateString(NULL, UUID));
    CFRelease(UUID);
    
    NSString *URLString = [[NSString alloc] initWithFormat:@"https://github.com/login/oauth/authorize?client_id=%@&scope=%@&state=%@", github_client_id, @"user,repo", self.UUID];
    NSURL *URL = [NSURL URLWithString:URLString];
    
    self.request = [NSURLRequest requestWithURL:URL];
}

@end
