//
//  ADShowCaseItemViewModel.m
//  Scarecrow
//
//  Created by duanhongjin on 2017/5/1.
//  Copyright © 2017年 duanhongjin. All rights reserved.
//

#import "ADShowCaseItemViewModel.h"
#import "ADModelShowCase.h"

@interface ADShowCaseItemViewModel ()

@property (strong, nonatomic) ADModelShowCase *showCase;

@property (assign, nonatomic) CGFloat height;

@end

@implementation ADShowCaseItemViewModel

- (instancetype)initWithShowCase:(ADModelShowCase *)showCase {
    self = [super init];
    if (self) {
        self.showCase = showCase;
        self.height = [self caculCellHeight];
    }
    return self;
}

- (CGFloat)caculCellHeight {
    
    // image size
    CGFloat minHeight = 15 * 2 + 43;
    
    NSDictionary *dic = @{NSFontAttributeName : [UIFont systemFontOfSize:15]};
    CGFloat width = LAYOUT_DEFAULT_WIDTH - 15 - 43 - 8 - 15;
    CGRect rect = [self.desc boundingRectWithSize:CGSizeMake(width, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
    
    return MAX(minHeight, rect.size.height + 15 + 21 + 10 + 15);
}

- (NSString *)name {
    return self.showCase.name;
}

- (NSString *)desc {
    return self.showCase.desc ?: @"No description";
}

- (NSURL *)imageURL {
    return [NSURL URLWithString:self.showCase.imageURL];
}

@end
