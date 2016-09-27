//
//  ADFollowButton.m
//  Scarecrow
//
//  Created by duanhongjin on 8/20/16.
//  Copyright © 2016 duanhongjin. All rights reserved.
//

#import "ADFollowButton.h"
#import "UIColor+Scarecrow.h"

@implementation ADFollowButton

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    self.layer.cornerRadius = 5;
    self.layer.masksToBounds = YES;
    self.layer.borderColor = RGB(0xd5d5d5).CGColor;
    
    self.titleLabel.font = [UIFont systemFontOfSize:15];
    self.contentEdgeInsets = UIEdgeInsetsMake(7, 10, 7, 10);
    
    [self setTitle:@"Follow" forState:UIControlStateNormal];
    [self setTitleColor:RGB(0xFFFFFF) forState:UIControlStateNormal];
    [self setTitleShadowColor:RGB(0x555555) forState:UIControlStateNormal];
    
    [self setTitle:@"Unfollow" forState:UIControlStateSelected];
    [self setTitleColor:RGB(0x333333) forState:UIControlStateSelected];
    
    @weakify(self);
    [RACObserve(self, selected) subscribeNext:^(NSNumber *selected) {
        @strongify(self);
        if (selected.boolValue) {
            self.backgroundColor = RGB(0xEEEEEE);
        } else {
            self.backgroundColor = RGB(0x569E3D);
        }
    }];
}

@end
