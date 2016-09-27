//
//  ADReposDescTableViewCell.m
//  Scarecrow
//
//  Created by duanhongjin on 9/17/16.
//  Copyright © 2016 duanhongjin. All rights reserved.
//

#import "ADReposDescTableViewCell.h"
#import "ADReposDetailViewModel.h"

@implementation ADReposDescTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.textLabel.font = [UIFont systemFontOfSize:15];
        self.textLabel.numberOfLines = 0;
    }
    return self;
}

- (void)bindViewModel:(ADReposDetailViewModel *)viewModel {
    self.textLabel.text = viewModel.repos.repoDescription;
}

@end
