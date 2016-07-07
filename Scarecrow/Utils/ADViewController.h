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

@property (strong, nonatomic, readonly) ADViewModel *viewModel;

- (instancetype)initWithViewModel:(ADViewModel *)viewModel;
- (void)bindViewModel;

@end
