//
//  ADTabBarViewModel.h
//  Scarecrow
//
//  Created by duanhongjin on 16/7/24.
//  Copyright © 2016年 duanhongjin. All rights reserved.
//

#import "ADViewModel.h"

@class ADSubscribeViewModel;

@interface ADTabBarViewModel : ADViewModel

@property (strong, nonatomic, readonly) ADSubscribeViewModel *subscribeViewModel;

@end
