//
//  ADReposViewCodeTableViewCell.h
//  Scarecrow
//
//  Created by duanhongjin on 9/12/16.
//  Copyright © 2016 duanhongjin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ADReposViewCodeTableViewCell : UITableViewCell

@property (weak, nonatomic, readonly) UIImageView *branchIcon;
@property (weak, nonatomic, readonly) UIButton *branchButton;
@property (weak, nonatomic, readonly) UILabel *timeLabel;
@property (weak, nonatomic, readonly) UIButton *viewCodeButton;

@end
