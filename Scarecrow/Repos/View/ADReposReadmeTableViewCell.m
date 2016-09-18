//
//  ADReposReadmeTableViewCell.m
//  Scarecrow
//
//  Created by duanhongjin on 9/18/16.
//  Copyright © 2016 duanhongjin. All rights reserved.
//

#import "ADReposReadmeTableViewCell.h"
#import "UIColor+Scarecrow.h"
#import "UIImage+Octions.h"
#import "ADReposDetailViewModel.h"

@interface ADReposReadmeTableViewCell ()

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *separator1Height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *separator2Height;
@property (weak, nonatomic) IBOutlet UIImageView *readmeImageView;
@property (weak, nonatomic) IBOutlet UIButton *viewReadmeButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIWebView *webview;
@end

@implementation ADReposReadmeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.containerView.layer.borderColor = RGB(0x999999).CGColor;
    self.containerView.layer.borderWidth = AD_1PX;
    self.containerView.layer.cornerRadius = 3;
    
    self.readmeImageView.image = [UIImage ad_normalImageWithIdentifier:@"Book" size:CGSizeMake(24, 24)];
    
    [self.activityIndicator startAnimating];
    
    self.separator1Height.constant = AD_1PX;
    self.separator2Height.constant = AD_1PX;
    
    self.webview.scrollView.scrollEnabled = NO;
    
    CGRect frame = self.webview.frame;
    frame.size.height = 1;
    
    self.webview.frame = frame;
}

- (void)bindViewModel:(ADReposDetailViewModel *)viewModel {
    @weakify(self);
    [[[RACObserve(viewModel, readmeHTML)ignore:nil]deliverOnMainThread]subscribeNext:^(NSString *readmeHTML) {
        @strongify(self);
        [self.webview loadHTMLString:readmeHTML baseURL:nil];
    }];
    
    self.viewReadmeButton.rac_command = viewModel.viewReadmeCommand;
}

- (CGFloat)height {
    return 40 + self.webview.frame.size.height + 40;
}

@end
