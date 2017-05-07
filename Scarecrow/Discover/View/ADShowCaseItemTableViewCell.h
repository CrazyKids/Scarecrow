//
//  ADShowCaseItemTableViewCell.h
//  Scarecrow
//
//  Created by duanhongjin on 2017/5/1.
//  Copyright © 2017年 duanhongjin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ADShowCaseItemViewModel;

@interface ADShowCaseItemTableViewCell : UITableViewCell

- (void)bindModel:(ADShowCaseItemViewModel *)model;

@end
