//
//  ADUserListViewModel.h
//  Scarecrow
//
//  Created by duanhongjin on 8/20/16.
//  Copyright © 2016 duanhongjin. All rights reserved.
//

#import "ADTableViewModel.h"

@interface ADUserListViewModel : ADTableViewModel

@property (strong, nonatomic, readonly) OCTUser *user;

@property (assign, nonatomic, readonly) BOOL isCurrentUser;
@property (copy, nonatomic, readonly) NSArray *userArray;

@property (strong, nonatomic) RACCommand *operationCommand;

@end
