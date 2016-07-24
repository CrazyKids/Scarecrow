//
//  ADTabBarController.h
//  Scarecrow
//
//  Created by duanhongjin on 16/7/24.
//  Copyright © 2016年 duanhongjin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ADTabBarController : UITabBarController

@property (strong, nonatomic, readonly) ADViewModel *viewModel;

- (instancetype)initWithViewModel:(ADViewModel *)viewModel;
- (void)bindViewModel;

@end
