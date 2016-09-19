//
//  ADReposOwnerTableViewCell.h
//  Scarecrow
//
//  Created by duanhongjin on 16/9/20.
//  Copyright © 2016年 duanhongjin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ADReposSettingsViewModel;

@interface ADReposOwnerTableViewCell : UITableViewCell

- (void)bindViewModel:(ADReposSettingsViewModel *)viewModel;

@end
