//
//  ADReposStatisticsTableViewCell.h
//  Scarecrow
//
//  Created by duanhongjin on 9/12/16.
//  Copyright © 2016 duanhongjin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ADReposStatisticsTableViewCell : UITableViewCell

@property (weak, nonatomic, readonly) UILabel *starCountLabel;
@property (weak, nonatomic, readonly) UILabel *forkCountLabel;

@end
