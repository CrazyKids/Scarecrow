//
//  ADDiscoverItemViewModel.m
//  Scarecrow
//
//  Created by duanhongjin on 17/03/2017.
//  Copyright © 2017 duanhongjin. All rights reserved.
//

#import "ADDiscoverItemViewModel.h"

@interface ADDiscoverItemViewModel ()

@property (copy, nonatomic) NSString *itemName;
@property (strong, nonatomic) UIImage *itemIcon;
@property (strong, nonatomic) RACCommand *itemCommand;

@end

@implementation ADDiscoverItemViewModel

- (instancetype)initWithParam:(NSDictionary *)param {
    self = [super initWithParam:param];
    if (self) {
        self.itemName = param[@"itemName"];
        self.itemIcon = param[@"itemIcon"];
        self.itemCommand = param[@"itemCommand"];
    }
    return self;
}

@end
