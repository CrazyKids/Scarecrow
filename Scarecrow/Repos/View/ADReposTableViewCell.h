//
//  ADReposTableViewCell.h
//  Scarecrow
//
//  Created by duanhongjin on 16/9/7.
//  Copyright © 2016年 duanhongjin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ADReposItemViewModel;

@interface ADReposTableViewCell : UITableViewCell

- (void)bindViewModel:(ADReposItemViewModel *)viewModel;

@end
