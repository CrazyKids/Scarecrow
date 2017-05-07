//
//  ADPopularUsersViewModel.h
//  Scarecrow
//
//  Created by duanhongjin on 2017/3/19.
//  Copyright © 2017年 duanhongjin. All rights reserved.
//

#import "ADUserListViewModel.h"

@interface ADPopularUsersViewModel : ADUserListViewModel

@property (strong, nonatomic) NSDictionary *country;
@property (strong, nonatomic) NSDictionary *language;

@property (strong, nonatomic, readonly) NSArray *popoverMenus;
@property (strong, nonatomic, readonly) RACCommand *popoverCommand;

@end
