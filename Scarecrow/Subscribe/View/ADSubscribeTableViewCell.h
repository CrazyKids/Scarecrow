//
//  ADSubscribeTableViewCell.h
//  Scarecrow
//
//  Created by duanhongjin on 8/4/16.
//  Copyright © 2016 duanhongjin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ADSubscribeItemViewModel.h"

@interface ADSubscribeTableViewCell : UITableViewCell

- (void)bindViewModel:(ADSubscribeItemViewModel *)viewModel;

@end
