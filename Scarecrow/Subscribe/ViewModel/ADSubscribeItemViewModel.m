//
//  ADSubscribeItemViewModel.m
//  Scarecrow
//
//  Created by duanhongjin on 8/4/16.
//  Copyright © 2016 duanhongjin. All rights reserved.
//

#import "ADSubscribeItemViewModel.h"
#import <YYKit/YYKit.h>
#import "OCTEvent+AttributedString.h"

@interface ADSubscribeItemViewModel ()

@property (strong, nonatomic) OCTEvent *event;
@property (strong, nonatomic) NSAttributedString *attributedString;

@end

@implementation ADSubscribeItemViewModel

- (instancetype)initWithEvent:(OCTEvent *)event {
    self = [super init];
    if (self) {
        self.event = event;
        self.attributedString = event.ad_attributedString;
        
        YYTextContainer *container = [YYTextContainer new];
        container.size = CGSizeMake(LAYOUT_DEFAULT_WIDTH - 65 - 15, MAXFLOAT);
//        container.maximumNumberOfRows = 10;
        container.truncationType = YYTextTruncationTypeEnd;
        
        self.textLayout = [YYTextLayout layoutWithContainer:container text:self.attributedString];
        
        CGFloat height = 0;
        height += 10 + self.textLayout.textBoundingSize.height + 10;
        self.height = height;
    }
    return self;
}

@end
