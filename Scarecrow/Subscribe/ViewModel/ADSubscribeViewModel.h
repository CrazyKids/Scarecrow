//
//  ADSubscribeViewModel.h
//  Scarecrow
//
//  Created by duanhongjin on 16/7/24.
//  Copyright © 2016年 duanhongjin. All rights reserved.
//

#import "ADTableViewModel.h"

@interface ADSubscribeViewModel : ADTableViewModel

@property (strong, nonatomic, readonly) OCTUser *user;

@property (strong, nonatomic, readonly) NSArray *eventArray;
@property (assign, nonatomic, readonly) BOOL isCurrentUser;
@property (strong, nonatomic, readonly) RACCommand *didClickLinkCommand;

- (NSArray *)dataSourceWithEvents:(NSArray *)eventArray;
- (void)saveEvents:(NSArray *)eventArray;

@end
