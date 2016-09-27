//
//  ADReposViewCodeTableViewCell.m
//  Scarecrow
//
//  Created by duanhongjin on 9/12/16.
//  Copyright © 2016 duanhongjin. All rights reserved.
//

#import "ADReposViewCodeTableViewCell.h"
#import "UIColor+Scarecrow.h"
#import "ADReposDetailViewModel.h"
#import "OCTRef+Scarecrow.h"
#import "UIImage+Octions.h"

@interface ADReposViewCodeTableViewCell ()

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIImageView *branchIcon;
@property (weak, nonatomic) IBOutlet UIButton *branchButton;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *viewCodeButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *separator1Height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *separator2Height;

@end

@implementation ADReposViewCodeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.containerView.layer.borderColor = RGB(0x999999).CGColor;
    self.containerView.layer.borderWidth = AD_1PX;
    self.containerView.layer.cornerRadius = 3;
    
    self.separator1Height.constant = AD_1PX;
    self.separator2Height.constant = AD_1PX;
}

- (void)bindViewModel:(ADReposDetailViewModel *)viewModel {
    [RACObserve(viewModel, reference)subscribeNext:^(OCTRef *reference) {
        self.branchIcon.image = [UIImage ad_normalImageWithIdentifier:reference.ad_octiconIdentifier size:CGSizeMake(24, 24)];
        NSString *title = [reference.name componentsSeparatedByString:@"/"].lastObject;
        [self.branchButton setTitle:title forState:UIControlStateNormal];
    }];
    
    self.timeLabel.text = viewModel.dateUpdated;
    
    UIImage *image = [UIImage ad_highlightImageWithIdentifier:@"FileDirectory" size:CGSizeMake(22, 22)];
    [self.viewCodeButton setImage:image forState:UIControlStateNormal];
    
    self.viewCodeButton.rac_command = viewModel.viewCodeCommand;
    self.branchButton.rac_command = viewModel.changeBranchCommand;
}

@end
