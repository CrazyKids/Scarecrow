//
//  ADSubscribeTableViewCell.m
//  Scarecrow
//
//  Created by duanhongjin on 16/9/11.
//  Copyright © 2016年 duanhongjin. All rights reserved.
//

#import "ADSubscribeTableViewCell.h"

#import "ADSubscribeTableViewCell.h"
#import <YYKit/YYKit.h>
#import <SDWebImage/UIButton+WebCache.h>
#import "NSURL+Scarecrow.h"

@interface ADSubscribeTableViewCell ()

@property (strong, nonatomic) ADSubscribeItemViewModel *viewModel;
@property (weak, nonatomic) IBOutlet UIButton *avatarButton;
@property (strong, nonatomic) YYLabel *detailLabel;

@end

@implementation ADSubscribeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.detailLabel = [YYLabel new];
    [self.contentView addSubview:self.detailLabel];
    
    self.detailLabel.top = 10;
    self.detailLabel.left = 65;
    self.detailLabel.width = LAYOUT_DEFAULT_WIDTH - 65 - 15;
    self.detailLabel.displaysAsynchronously = YES;
    self.detailLabel.ignoreCommonProperties = YES;
    
    // default setting
    self.avatarButton.backgroundColor = [UIColor clearColor];
    
    @weakify(self);
    [[self.avatarButton rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        @strongify(self);
        
        [self.viewModel.didClickLinkCommand execute:[NSURL ad_userLink:self.viewModel.event.actorLogin]];
    }];
    
    self.detailLabel.highlightTapAction = ^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect) {
        @strongify(self);
        
        text = [text attributedSubstringFromRange:range];
        
        NSDictionary *dic = [text attributesAtIndex:0 effectiveRange:NULL];
        NSURL *url = dic[kLinkAttributeKey];
        [self.viewModel.didClickLinkCommand execute:url];
    };
}

- (void)bindViewModel:(ADSubscribeItemViewModel *)viewModel {
    self.viewModel = viewModel;
    
    [self.avatarButton sd_setImageWithURL:viewModel.event.actorAvatarURL forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"default_avatar"]];
    self.detailLabel.height = viewModel.textLayout.textBoundingSize.height;
    self.detailLabel.textLayout = viewModel.textLayout;
}

@end
