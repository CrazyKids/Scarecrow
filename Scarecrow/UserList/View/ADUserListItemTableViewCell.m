//
//  ADUserListItemTableViewCell.m
//  Scarecrow
//
//  Created by duanhongjin on 8/23/16.
//  Copyright © 2016 duanhongjin. All rights reserved.
//

#import "ADUserListItemTableViewCell.h"
#import "ADFollowButton.h"
#import "ADUserListItemViewModel.h"
#import "OCTUser+Persistence.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface ADUserListItemTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *loginLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

@property (strong, nonatomic) ADUserListItemViewModel *viewModel;

@end

@implementation ADUserListItemTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)bindViewModel:(ADUserListItemViewModel *)viewModel {
    self.viewModel = viewModel;
    
    [self.avatarImageView sd_setImageWithURL:viewModel.user.avatarURL placeholderImage:[UIImage imageNamed:@"default_avatar"]];
    
    self.loginLabel.text = viewModel.login;
    self.detailLabel.text = viewModel.user.HTMLURL.absoluteString;
}

- (IBAction)onOperationButtonClicked:(UIButton *)sender {
    sender.enabled = NO;
    [[[self.viewModel.operationCommand execute:self.viewModel]deliverOnMainThread]subscribeCompleted:^{
        sender.enabled = YES;
    }];
}

@end
