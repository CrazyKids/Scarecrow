//
//  ADSubscribeItemViewModel.h
//  Scarecrow
//
//  Created by duanhongjin on 8/4/16.
//  Copyright © 2016 duanhongjin. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YYTextLayout;

@interface ADSubscribeItemViewModel : NSObject

@property (strong, nonatomic, readonly) OCTEvent *event;
@property (strong, nonatomic, readonly) NSAttributedString *attributedString;

@property (assign, nonatomic) CGFloat height;
@property (strong, nonatomic) RACCommand *didClickLinkCommand;
@property (strong, nonatomic) YYTextLayout *textLayout;

- (instancetype)initWithEvent:(OCTEvent *)event;

@end
