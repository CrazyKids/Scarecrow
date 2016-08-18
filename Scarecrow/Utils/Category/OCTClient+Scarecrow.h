//
//  OCTClient+Scarecrow.h
//  Scarecrow
//
//  Created by duanhongjin on 8/18/16.
//  Copyright © 2016 duanhongjin. All rights reserved.
//

#import <OctoKit/OctoKit.h>

@interface OCTClient (Scarecrow)

- (RACSignal *)ad_followUser:(OCTUser *)user;
- (RACSignal *)ad_unfollowUser:(OCTUser *)user;

@end
