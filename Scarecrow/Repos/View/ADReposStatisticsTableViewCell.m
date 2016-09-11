//
//  ADReposStatisticsTableViewCell.m
//  Scarecrow
//
//  Created by duanhongjin on 9/12/16.
//  Copyright © 2016 duanhongjin. All rights reserved.
//

#import "ADReposStatisticsTableViewCell.h"
#import "UIColor+Scarecrow.h"

@interface ADReposStatisticsTableViewCell ()

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UILabel *starCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *forkCountLabel;

@end

@implementation ADReposStatisticsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.containerView.layer.borderWidth = 1.0f;
    self.containerView.layer.borderColor = RGB(0x999999).CGColor;
    self.containerView.layer.cornerRadius = 3;
}

@end
