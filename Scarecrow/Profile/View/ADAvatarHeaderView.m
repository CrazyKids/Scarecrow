//
//  ADAvatarHeaderView.m
//  Scarecrow
//
//  Created by duanhongjin on 8/13/16.
//  Copyright © 2016 duanhongjin. All rights reserved.
//

#import "ADAvatarHeaderView.h"
#import "ADAvatarHeaderViewModel.h"
#import "OCTUser+Persistence.h"
#import <WebImage/SDWebImageManager.h>
#import <GPUImage/GPUImageFramework.h>
#import "UIColor+Scarecrow.h"

@interface ADAvatarHeaderView ()

@property (weak, nonatomic) IBOutlet UIView *containerView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *followersLabel;
@property (weak, nonatomic) IBOutlet UILabel *reposLabel;
@property (weak, nonatomic) IBOutlet UILabel *followingLabel;

@property (weak, nonatomic) IBOutlet UIButton *avatarButton;
@property (weak, nonatomic) IBOutlet UIButton *followersButton;
@property (weak, nonatomic) IBOutlet UIButton *reposButton;
@property (weak, nonatomic) IBOutlet UIButton *followingButton;
@property (weak, nonatomic) IBOutlet UIButton *operationButton;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;

@property (strong, nonatomic) UIImage *avatarImage;
@property (strong, nonatomic) ADAvatarHeaderViewModel *viewModel;

@property (strong, nonatomic) UIImageView *coverImageView;
@property (strong, nonatomic) UIImageView *blurCoverImageView;

@property (strong, nonatomic) GPUImageGaussianBlurFilter *blurFilter;

@end

@implementation ADAvatarHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.avatarButton.imageView.layer.borderColor  = [UIColor whiteColor].CGColor;
    self.avatarButton.imageView.layer.borderWidth  = 2;
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
    
    self.coverImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, LAYOUT_DEFAULT_WIDTH, 380 - 57)];
    self.coverImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.coverImageView.clipsToBounds = YES;
    
    self.blurCoverImageView = [[UIImageView alloc]initWithFrame:self.coverImageView.bounds];
    self.blurCoverImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.blurCoverImageView.clipsToBounds = YES;
    
    [self.coverImageView addSubview:self.blurCoverImageView];
    [self insertSubview:self.coverImageView atIndex:0];
    
    // 模拟器上不具备此功能，而且特别慢
#if !TARGET_IPHONE_SIMULATOR
    self.blurFilter = [GPUImageGaussianBlurFilter new];
    self.blurFilter.blurRadiusInPixels = 20.0;
#endif
    
    RAC(self.coverImageView, image) = RACObserve(self, avatarImage);
    RAC(self.blurCoverImageView, image) = [RACObserve(self, avatarImage) map:^id(UIImage *avatarImage) {
        @strongify(self);
        return [self.blurFilter imageByFilteringImage:avatarImage];
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
    
    RAC(self.followersLabel, text) = [RACObserve(self.viewModel.user, followers) map:toString];
    RAC(self.reposLabel, text) = [RACObserve(self.viewModel.user, publicRepoCount) map:toString];
    RAC(self.followingLabel, text) = [RACObserve(self.viewModel.user, following) map:toString];
    
    self.followingButton.rac_command = self.viewModel.followingCommand;
    self.reposButton.rac_command = self.viewModel.reposCommand;
    self.followersButton.rac_command = self.viewModel.followersCommand;
    
    [[RACObserve(self.viewModel, contentOffset) filter:^BOOL(NSNumber *offset) {
        return [offset CGPointValue].y <= 0;
    }]subscribeNext:^(id x) {
        @strongify(self);
        
        CGPoint contentOffset = [x CGPointValue];
        
        self.coverImageView.frame = CGRectMake(0, 0 + contentOffset.y, LAYOUT_DEFAULT_WIDTH, CGRectGetHeight(self.frame) + ABS(contentOffset.y) - 58);
        self.blurCoverImageView.frame = CGRectMake(0, 0, CGRectGetWidth(self.coverImageView.frame), CGRectGetHeight(self.coverImageView.frame));
        
        CGFloat diff = MIN(ABS(contentOffset.y), 40.0);
        CGFloat scale = diff / 40.0;
        
        CGFloat alpha = 1 * (1 - scale);
        
        self.avatarButton.imageView.alpha = alpha;
        self.nameLabel.alpha = alpha;
        self.operationButton.alpha = alpha;
        self.blurCoverImageView.alpha = alpha;
    }];
}

@end
