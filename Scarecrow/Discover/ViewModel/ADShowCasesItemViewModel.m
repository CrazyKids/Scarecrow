//
//  ADShowCasesItemViewModel.m
//  Scarecrow
//
//  Created by duanhongjin on 2017/5/1.
//  Copyright © 2017年 duanhongjin. All rights reserved.
//

#import "ADShowCasesItemViewModel.h"
#import "ADModelShowCases.h"

@interface ADShowCasesItemViewModel ()

@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *slug;
@property (copy, nonatomic) NSString *desc;
@property (copy, nonatomic) NSURL *imageURL;

@property (assign, nonatomic) CGFloat height;

@end

@implementation ADShowCasesItemViewModel

- (instancetype)initWithShowCase:(ADModelShowCases *)showCase {
    self = [super init];
    if (self) {
        self.name = showCase.name;
        self.slug = showCase.slug;
        self.desc = showCase.desc;
        self.imageURL = [NSURL URLWithString:showCase.imageURL];
        self.height = [self caculCellHeight];
    }
    return self;
}

- (CGFloat)caculCellHeight {
    
    // image size
    CGFloat minHeight = 15 * 2 + 43;
    if (!self.desc.length) {
        return minHeight;
    }
    
    NSDictionary *dic = @{NSFontAttributeName : [UIFont systemFontOfSize:15]};
    CGFloat width = LAYOUT_DEFAULT_WIDTH - 15 - 43 - 8 - 15;
    CGRect rect = [self.desc boundingRectWithSize:CGSizeMake(width, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
    
    return MAX(minHeight, rect.size.height + 15 + 21 + 10 + 15);
}

@end
