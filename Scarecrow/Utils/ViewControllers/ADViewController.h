//
//  ADViewController.h
//  Scarecrow
//
//  Created by duanhongjin on 7/7/16.
//  Copyright © 2016 duanhongjin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ADViewModel.h"

@interface ADViewController : UIViewController

@property (strong, nonatomic, readonly) __kindof ADViewModel *viewModel;

- (instancetype)initWithViewModel:(ADViewModel *)viewModel;
- (void)initializeWithViewMode:(ADViewModel *)viewModel;

- (void)bindViewModel;

+ (__kindof ADViewController *)viewController;

@end
