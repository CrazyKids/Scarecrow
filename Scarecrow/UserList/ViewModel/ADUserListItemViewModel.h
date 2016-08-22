//
//  ADUserListItemViewModel.h
//  Scarecrow
//
//  Created by duanhongjin on 8/20/16.
//  Copyright © 2016 duanhongjin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ADUserListItemViewModel : NSObject

@property (strong, nonatomic) OCTUser *user;

@property (copy, nonatomic, readonly) NSURL *avatarURL;
@property (copy, nonatomic, readonly) NSString *login;

@property (strong, nonatomic) RACCommand *operationCommand;

- (instancetype)initWithUser:(OCTUser *)user;

@end
