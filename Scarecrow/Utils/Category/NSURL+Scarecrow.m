//
//  NSURL+Scarecrow.m
//  Scarecrow
//
//  Created by duanhongjin on 8/5/16.
//  Copyright © 2016 duanhongjin. All rights reserved.
//

#import "NSURL+Scarecrow.h"
#import "OCTRef+Scarecrow.h"

@implementation NSURL (Scarecrow)

+ (instancetype)ad_userLink:(NSString *)user {
    return [NSURL URLWithString:[NSString stringWithFormat:@"user://%@", user]];
}

+ (instancetype)ad_reposLink:(NSString *)repos referName:(NSString *)refer {
    if (!refer) {
        refer = [OCTRef ad_defaultReferenceName];
    }
    return [NSURL URLWithString:[NSString stringWithFormat:@"repository://%@", refer]];
}

- (ADLinkType)linkType {
    if ([self.scheme isEqualToString:@"user"]) {
        return ADLinkTypeUser;
    }
    
    if ([self.scheme isEqualToString:@"repository"]) {
        return ADLinkTypeRepos;
    }
    
    return ADLinkTypeNormal;
}

- (NSDictionary *)ad_dic {
    if (self.linkType == ADLinkTypeUser) {
        return @{@"user":@{@"login":self.host ?: @""}};
    }
    
    if (self.linkType == ADLinkTypeRepos) {
        return @{
                 @"repository":@{
                         @"ownerLogin":self.host ?: @"",
                         @"name":[self.path substringFromIndex:1] ?: @"",
                         },
                 @"referenceName":[self.query componentsSeparatedByString:@"="].lastObject ?: @"",
                 };
    }
    
    return nil;
}

@end
