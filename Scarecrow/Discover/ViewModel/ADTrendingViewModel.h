//
//  ADTrendingViewModel.h
//  Scarecrow
//
//  Created by duanhongjin on 2017/3/19.
//  Copyright © 2017年 duanhongjin. All rights reserved.
//

#import "ADViewModel.h"

@class ADTrendingReposViewModel;

@interface ADTrendingViewModel : ADViewModel

@property (strong, nonatomic, readonly) RACCommand *rightBarButtonCommand;

@property (strong, nonatomic, readonly) ADTrendingReposViewModel *dailyViewModel;
@property (strong, nonatomic, readonly) ADTrendingReposViewModel *weeklyViewModel;
@property (strong, nonatomic, readonly) ADTrendingReposViewModel *monthlyViewModel;

@end
