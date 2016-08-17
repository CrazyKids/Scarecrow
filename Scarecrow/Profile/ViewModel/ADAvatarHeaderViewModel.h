//
//  ADAvatarHeaderViewModel.h
//  Scarecrow
//
//  Created by duanhongjin on 8/13/16.
//  Copyright © 2016 duanhongjin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ADAvatarHeaderViewModel : NSObject

@property (strong, nonatomic, readonly) OCTUser *user;

@property (strong, nonatomic) RACCommand *followingCommand;
@property (strong, nonatomic) RACCommand *reposCommand;
@property (strong, nonatomic) RACCommand *followersCommand;
@property (strong, nonatomic) RACCommand *operationCommand;

@property (assign, nonatomic) CGPoint contentOffset;

- (instancetype)initWithUser:(OCTUser *)user;

@end
