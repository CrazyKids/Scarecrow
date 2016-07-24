//
//  OCTRef+Scarecrow.m
//  Scarecrow
//
//  Created by duanhongjin on 8/5/16.
//  Copyright © 2016 duanhongjin. All rights reserved.
//

#import "OCTRef+Scarecrow.h"

static NSString *const kRefBranchNamePrefix = @"refs/heads/";
static NSString *const kRefTagNamePrefix = @"refs/tags/";

@implementation OCTRef (Scarecrow)

+ (NSString *)ad_defaultReferenceName {
    return [kRefBranchNamePrefix stringByAppendingString:@"master"];
}

+ (NSString *)ad_referenceNameWithBranch:(NSString *)branch {
    NSCParameterAssert(branch.length > 0);
    return [NSString stringWithFormat:@"%@%@", kRefBranchNamePrefix, branch];
}

+ (NSString *)ad_referenceNameWithTag:(NSString *)tag {
    NSCParameterAssert(tag.length > 0);
    return [NSString stringWithFormat:@"%@%@", kRefTagNamePrefix, tag];
}

@end
