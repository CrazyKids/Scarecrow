//
//  OCTRef+Scarecrow.h
//  Scarecrow
//
//  Created by duanhongjin on 8/5/16.
//  Copyright © 2016 duanhongjin. All rights reserved.
//

#import <OctoKit/OctoKit.h>

@interface OCTRef (Scarecrow)

+ (NSString *)ad_defaultReferenceName;
+ (NSString *)ad_referenceNameWithBranch:(NSString *)branch;
+ (NSString *)ad_referenceNameWithTag:(NSString *)tag;

- (NSString *)ad_octiconIdentifier;

@end
