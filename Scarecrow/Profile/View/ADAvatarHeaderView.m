//
//  ADAvatarHeaderView.m
//  Scarecrow
//
//  Created by duanhongjin on 8/13/16.
//  Copyright © 2016 duanhongjin. All rights reserved.
//

#import "ADAvatarHeaderView.h"
#import "ADFollowButton.h"
#import "ADAvatarHeaderViewModel.h"
#import "OCTUser+Persistence.h"
#import <SDWebImage/SDWebImageManager.h>

@interface ADAvatarHeaderView ()

@property (weak, nonatomic) IBOutlet UIView *containerView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *followerLabel;
@property (weak, nonatomic) IBOutlet UILabel *reposLabel;
@property (weak, nonatomic) IBOutlet UILabel *followingLabel;

@property (weak, nonatomic) IBOutlet UIButton *avatarButton;
@property (weak, nonatomic) IBOutlet UIButton *followerButton;
@property (weak, nonatomic) IBOutlet UIButton *reposButton;
@property (weak, nonatomic) IBOutlet UIButton *followingButton;
@property (weak, nonatomic) IBOutlet ADFollowButton *operationButton;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;

@property (strong, nonatomic) UIImage *avatarImage;
@property (strong, nonatomic) ADAvatarHeaderViewModel *viewModel;

@end

@implementation ADAvatarHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.avatarButton.imageView.layer.borderColor  = [UIColor whiteColor].CGColor;
    self.avatarButton.imageView.layer.borderWidth  = 2;
    self.avatarButton.imageView.layer.cornerRadius = CGRectGetWidth(self.avatarButton.frame) / 2;
    self.avatarButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.avatarButton.backgroundColor = [UIColor clearColor];
    self.avatarImage = [UIImage imageNamed:@"default_avatar"];
}

- (void)bindViewModel:(ADAvatarHeaderViewModel *)viewModel {
    self.viewModel = viewModel;
    
    @weakify(self);
    [RACObserve(self, avatarImage) subscribeNext:^(UIImage *avatarImage) {
        @strongify(self);
        [self.avatarButton setImage:avatarImage forState:UIControlStateNormal];
    }];
    
    
    [self.activityIndicatorView startAnimating];
    if (!self.viewModel.operationCommand) {
        self.operationButton.hidden = YES;
        [self.activityIndicatorView stopAnimating];
        self.activityIndicatorView.hidden = YES;
    } else {
        self.operationButton.rac_command = self.viewModel.operationCommand;
        [[RACObserve(viewModel.user, followingStatus) deliverOnMainThread]subscribeNext:^(NSNumber *followingStatus) {
            @strongify(self);
            NSInteger status = followingStatus.integerValue;
            self.operationButton.selected = status == ADFollowStatusYes;
            self.activityIndicatorView.hidden = status != ADFollowStatusUnknown;
            self.operationButton.hidden = status == ADFollowStatusUnknown;
        }];
    }
    
    [[[RACObserve(viewModel.user, avatarURL) ignore:nil]distinctUntilChanged]subscribeNext:^(NSURL *avatarURL) {
        [[SDWebImageManager sharedManager]downloadImageWithURL:avatarURL options:SDWebImageRefreshCached progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            @strongify(self);
            if (image && finished) {
                self.avatarImage = image;
            }
        }];
    }];
    
    RAC(self.nameLabel, text) = RACObserve(self.viewModel.user, name);
    
    NSString *(^toString)(NSNumber *) = ^(NSNumber *value) {
        NSString *text = value.stringValue;
        
        if (value.integerValue > 1000) {
            text = [NSString stringWithFormat:@"%.1fk", value.integerValue / 1000.0f];
        }
        
        return text;
    };
    
    RAC(self.followerLabel, text) = [RACObserve(self.viewModel.user, followers) map:toString];
    RAC(self.reposLabel, text) = [RACObserve(self.viewModel.user, publicRepoCount) map:toString];
    RAC(self.followingLabel, text) = [RACObserve(self.viewModel.user, following) map:toString];
    
    self.followingButton.rac_command = self.viewModel.followingCommand;
    self.reposButton.rac_command = self.viewModel.reposCommand;
    self.followerButton.rac_command = self.viewModel.followersCommand;
}

@end
