//
//  OCTUser+Persistence.h
//  Scarecrow
//
//  Created by duanhongjin on 8/2/16.
//  Copyright © 2016 duanhongjin. All rights reserved.
//

#import <OctoKit/OctoKit.h>

@interface OCTUser (Persistence)

+ (instancetype)ad_currentUser;
+ (instancetype)ad_userWithRawLogin:(NSString *)rawLogin server:(OCTServer *)server;

- (void)ad_update;


@end
