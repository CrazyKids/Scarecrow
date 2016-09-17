//
//  ADReposDescTableViewCell.h
//  Scarecrow
//
//  Created by duanhongjin on 9/17/16.
//  Copyright © 2016 duanhongjin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ADReposDetailViewModel;

@interface ADReposDescTableViewCell : UITableViewCell

- (void)bindViewModel:(ADReposDetailViewModel *)viewModel;

@end
