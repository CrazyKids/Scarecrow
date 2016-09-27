//
//  ADReposViewCodeTableViewCell.h
//  Scarecrow
//
//  Created by duanhongjin on 9/12/16.
//  Copyright © 2016 duanhongjin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ADReposDetailViewModel;

@interface ADReposViewCodeTableViewCell : UITableViewCell

- (void)bindViewModel:(ADReposDetailViewModel *)viewModel;

@end
