//
//  ADReposStatisticsTableViewCell.m
//  Scarecrow
//
//  Created by duanhongjin on 9/12/16.
//  Copyright © 2016 duanhongjin. All rights reserved.
//

#import "ADReposStatisticsTableViewCell.h"
#import "UIColor+Scarecrow.h"
#import "ADReposDetailViewModel.h"

@interface ADReposStatisticsTableViewCell ()

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UILabel *starCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *forkCountLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *separatorWidth;

@end

@implementation ADReposStatisticsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.containerView.layer.borderWidth = AD_1PX;
    self.containerView.layer.borderColor = RGB(0x999999).CGColor;
    self.containerView.layer.cornerRadius = 3;
    
    self.separatorWidth.constant = AD_1PX;
}

- (void)bindViewModel:(ADReposDetailViewModel *)viewModel {    
    self.forkCountLabel.text = [NSString stringWithFormat:@"%ld", viewModel.repos.forksCount];
    self.starCountLabel.text = [NSString stringWithFormat:@"%ld", viewModel.repos.stargazersCount];
    
    [[RACObserve(viewModel.repos, stargazersCount) deliverOnMainThread]subscribeNext:^(NSNumber *stargazersCount) {
        self.starCountLabel.text = stargazersCount.stringValue;
    }];
}

@end
