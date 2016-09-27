//
//  ADSubscribeTableViewCell.h
//  Scarecrow
//
//  Created by duanhongjin on 16/9/11.
//  Copyright © 2016年 duanhongjin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ADSubscribeItemViewModel.h"

@interface ADSubscribeTableViewCell : UITableViewCell

- (void)bindViewModel:(ADSubscribeItemViewModel *)viewModel;

@end
