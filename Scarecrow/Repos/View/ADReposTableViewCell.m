//
//  ADReposTableViewCell.m
//  Scarecrow
//
//  Created by duanhongjin on 16/9/7.
//  Copyright © 2016年 duanhongjin. All rights reserved.
//

#import "ADReposTableViewCell.h"
#import "ADReposItemViewModel.h"
#import "UIImage+Octions.h"
#import "OCTRepository+Persistence.h"

@interface ADReposTableViewCell ()

@property (strong, nonatomic) ADReposItemViewModel *viewModel;

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *decriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *languageLabel;
@property (weak, nonatomic) IBOutlet UIImageView *starImageView;
@property (weak, nonatomic) IBOutlet UILabel *starCountLabel;
@property (weak, nonatomic) IBOutlet UIImageView *forkImageView;
@property (weak, nonatomic) IBOutlet UILabel *forkCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *updateTimeLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *starredLeadingConstaint;

@property (strong, nonatomic) UIImage *reposIcon;
@property (strong, nonatomic) UIImage *forkedReposIcon;
@property (strong, nonatomic) UIImage *privateRepoIcon;

@property (strong, nonatomic) UIImage *starIcon;
@property (strong, nonatomic) UIImage *tintedStarIcon;

@end

@implementation ADReposTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.reposIcon = [UIImage ad_normalImageWithIdentifier:@"Repo" size:self.iconImageView.bounds.size];
    self.forkedReposIcon = [UIImage ad_normalImageWithIdentifier:@"RepoForked" size:self.iconImageView.bounds.size];
    self.privateRepoIcon = [UIImage ad_normalImageWithIdentifier:@"Lock" size:self.iconImageView.bounds.size];
    self.starIcon = [UIImage ad_normalImageWithIdentifier:@"Star" size:self.starImageView.bounds.size];
    self.tintedStarIcon = [UIImage ad_highlightImageWithIdentifier:@"Star" size:self.starImageView.bounds.size];

    RAC(self.starImageView, image) = [[RACObserve(self, viewModel.repos.starStatus) map:^id(NSNumber *starStatus) {
        return starStatus.integerValue == ADReposStarStatusYes ? self.tintedStarIcon : self.starIcon;
    }]deliverOnMainThread];
    
    self.forkImageView.image = [UIImage ad_normalImageWithIdentifier:@"GitBranch" size:self.forkImageView.bounds.size];
    
    RAC(self.starCountLabel, text) = [[RACObserve(self, viewModel.repos.stargazersCount) map:^id(NSNumber *stargazersCount) {
        return stargazersCount.stringValue;
    }]deliverOnMainThread];
}

- (void)bindViewModel:(ADReposItemViewModel *)viewModel {
    self.viewModel = viewModel;
    
    if (viewModel.repos.isPrivate) {
        self.iconImageView.image = self.privateRepoIcon;
    } else if (viewModel.repos.isFork) {
        self.iconImageView.image = self.forkedReposIcon;
    } else {
        self.iconImageView.image = self.reposIcon;
    }
    
    self.nameLabel.attributedText = viewModel.name;
    self.decriptionLabel.attributedText = viewModel.reposDescription;
    self.languageLabel.text = viewModel.language;
    self.forkCountLabel.text = [NSString stringWithFormat:@"%ld", viewModel.repos.forksCount];
    self.updateTimeLabel.text = viewModel.udpateTime;
}

@end
