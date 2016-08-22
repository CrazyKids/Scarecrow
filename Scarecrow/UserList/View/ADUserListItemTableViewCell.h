//
//  ADUserListItemTableViewCell.h
//  Scarecrow
//
//  Created by duanhongjin on 8/23/16.
//  Copyright © 2016 duanhongjin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ADUserListItemViewModel;

@interface ADUserListItemTableViewCell : UITableViewCell

- (void)bindViewModel:(ADUserListItemViewModel *)viewModel;

@end
