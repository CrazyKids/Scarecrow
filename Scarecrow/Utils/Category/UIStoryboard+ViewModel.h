//
//  UIStoryboard+ViewModel.h
//  Scarecrow
//
//  Created by duanhongjin on 7/8/16.
//  Copyright © 2016 duanhongjin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ADViewModel;

@interface UIStoryboard (ViewModel)

- (__kindof UIViewController *)instantiateViewControllerWithIdentifier:(NSString *)identifier viewModel:(ADViewModel *)viewModel;

- (__kindof UIViewController *)instantiateInitialViewControllerWithViewModel:(ADViewModel *)viewModel;

@end
