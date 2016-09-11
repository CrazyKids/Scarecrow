//
//  ADReposViewCodeTableViewCell.m
//  Scarecrow
//
//  Created by duanhongjin on 9/12/16.
//  Copyright © 2016 duanhongjin. All rights reserved.
//

#import "ADReposViewCodeTableViewCell.h"
#import "UIColor+Scarecrow.h"

@interface ADReposViewCodeTableViewCell ()

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIImageView *branchIcon;
@property (weak, nonatomic) IBOutlet UIButton *branchButton;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *viewCodeButton;

@end

@implementation ADReposViewCodeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.containerView.layer.borderColor = RGB(0x999999).CGColor;
    self.containerView.layer.borderWidth = 1;
    self.containerView.layer.cornerRadius = 3;
}

@end
