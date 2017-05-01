//
//  ADShowCaseItemTableViewCell.m
//  Scarecrow
//
//  Created by duanhongjin on 2017/5/1.
//  Copyright © 2017年 duanhongjin. All rights reserved.
//

#import "ADShowCaseItemTableViewCell.h"
#import "ADShowCasesItemViewModel.h"
#import <WebImage/UIImageView+WebCache.h>

@interface ADShowCaseItemTableViewCell ()

@property (strong, nonatomic) ADShowCasesItemViewModel *viewModel;

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;


@end

@implementation ADShowCaseItemTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)bindModel:(ADShowCasesItemViewModel *)model {
    self.viewModel = model;
    
    [self.iconImageView sd_setImageWithURL:model.imageURL placeholderImage:[UIImage imageNamed:@"default_avatar"]];
    self.nameLabel.text = model.name;
    self.descLabel.text = model.desc;
}

@end
