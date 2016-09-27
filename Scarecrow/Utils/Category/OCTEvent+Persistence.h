//
//  OCTEvent+Persistence.h
//  Scarecrow
//
//  Created by duanhongjin on 8/4/16.
//  Copyright © 2016 duanhongjin. All rights reserved.
//

#import <OctoKit/OctoKit.h>

@interface OCTEvent (Persistence)

+ (BOOL)ad_saveUserReceivedEvents:(NSArray *)eventArray;
+ (BOOL)ad_saveUserPerformedEvents:(NSArray *)eventArray;
+ (NSArray *)ad_fetchUserReceivedEvents;
+ (NSArray *)ad_fetchUserPerformedEvents;

@end

@interface OCTEvent (NSURL)

- (NSURL *)ad_link;

@end
