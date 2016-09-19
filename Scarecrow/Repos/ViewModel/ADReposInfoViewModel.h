//
//  ADReposInfoViewModel.h
//  Scarecrow
//
//  Created by duanhongjin on 16/9/19.
//  Copyright © 2016年 duanhongjin. All rights reserved.
//

#import "ADWebViewModel.h"

@interface ADReposInfoViewModel : ADWebViewModel

@property (strong, nonatomic, readonly) OCTRepository *repos;
@property (strong, nonatomic, readonly) RACCommand *rightBarCommand;

@end
