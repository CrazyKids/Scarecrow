//
//  ADReposOwnerTableViewCell.m
//  Scarecrow
//
//  Created by duanhongjin on 16/9/20.
//  Copyright © 2016年 duanhongjin. All rights reserved.
//

#import "ADReposOwnerTableViewCell.h"
#import "ADReposSettingsViewModel.h"
#import <SDWebImage/SDWebImageManager.h>

@interface ADReposOwnerTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *ownerLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (strong, nonatomic) UIImage *avatarImage;

@end

@implementation ADReposOwnerTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.avatarImage = [UIImage imageNamed:@"default_avatar"];
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    @weakify(self);
    [RACObserve(self, avatarImage) subscribeNext:^(UIImage *avatarImage) {
        @strongify(self);
        self.avatarImageView.image = avatarImage;
    }];
}

- (void)bindViewModel:(ADReposSettingsViewModel *)viewModel {
    self.ownerLabel.text = viewModel.repos.ownerLogin;
    self.nameLabel.text = viewModel.repos.name;
    
    @weakify(self);
    [[[RACObserve(viewModel.repos, ownerAvatarURL) ignore:nil]distinctUntilChanged]subscribeNext:^(NSURL *avatarURL) {
        [[SDWebImageManager sharedManager]downloadImageWithURL:avatarURL options:SDWebImageRefreshCached progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            @strongify(self);
            if (image && finished) {
                self.avatarImage = image;
            }
        }];
    }];
}

@end
