//
//  ADPopularReposViewModel.h
//  Scarecrow
//
//  Created by duanhongjin on 2017/3/25.
//  Copyright © 2017年 duanhongjin. All rights reserved.
//

#import "ADReposViewModel.h"

@interface ADPopularReposViewModel : ADReposViewModel

@property (strong, nonatomic, readonly) NSDictionary *language;
@property (strong, nonatomic, readonly) RACCommand *rightBarButtonCommand;

@end
