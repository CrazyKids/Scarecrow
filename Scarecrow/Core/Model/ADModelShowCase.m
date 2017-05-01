//
//  ADModelShowCase.m
//  Scarecrow
//
//  Created by duanhongjin on 2017/3/27.
//  Copyright © 2017年 duanhongjin. All rights reserved.
//

#import "ADModelShowCase.h"

@implementation ADModelShowCase

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    NSDictionary *param = @{@"desc":@"description",
                            @"imageURL":@"image_url"};
    
    return [super.JSONKeyPathsByPropertyKey mtl_dictionaryByAddingEntriesFromDictionary:param];
}

@end
