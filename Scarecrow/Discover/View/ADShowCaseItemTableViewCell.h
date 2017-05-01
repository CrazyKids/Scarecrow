//
//  ADShowCaseItemTableViewCell.h
//  Scarecrow
//
//  Created by duanhongjin on 2017/5/1.
//  Copyright © 2017年 duanhongjin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ADShowCasesItemViewModel;

@interface ADShowCaseItemTableViewCell : UITableViewCell

- (void)bindModel:(ADShowCasesItemViewModel *)model;

@end
