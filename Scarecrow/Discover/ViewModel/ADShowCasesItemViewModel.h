//
//  ADShowCasesItemViewModel.h
//  Scarecrow
//
//  Created by duanhongjin on 2017/5/1.
//  Copyright © 2017年 duanhongjin. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ADModelShowCases;

@interface ADShowCasesItemViewModel : NSObject

@property (copy, nonatomic, readonly) NSString *name;
@property (copy, nonatomic, readonly) NSString *slug;
@property (copy, nonatomic, readonly) NSString *desc;
@property (copy, nonatomic, readonly) NSURL *imageURL;

@property (assign, nonatomic, readonly) CGFloat height;

- (instancetype)initWithShowCase:(ADModelShowCases *)showCase;

@end
