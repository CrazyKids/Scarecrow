//
//  NSURL+Scarecrow.h
//  Scarecrow
//
//  Created by duanhongjin on 8/5/16.
//  Copyright © 2016 duanhongjin. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, ADLinkType) {
    ADLinkTypeNormal,
    ADLinkTypeUser,
    ADLinkTypeRepos
};

@interface NSURL (Scarecrow)

@property (assign, nonatomic, readonly) ADLinkType linkType;

+ (instancetype)ad_userLink:(NSString *)user;
+ (instancetype)ad_reposLink:(NSString *)repos referName:(NSString *)refer;

- (NSDictionary *)ad_dic;

@end

