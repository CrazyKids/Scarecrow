//
//  ADReposReadmeTableViewCell.m
//  Scarecrow
//
//  Created by duanhongjin on 9/12/16.
//  Copyright © 2016 duanhongjin. All rights reserved.
//

#import "ADReposReadmeTableViewCell.h"
#import "UIColor+Scarecrow.h"
#import "UIImage+Octions.h"

@interface ADReposReadmeTableViewCell ()

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIImageView *readmeIcon;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIButton *readmeButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *separator1Height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *separator2Height;

@end

@implementation ADReposReadmeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.containerView.layer.borderColor = RGB(0x999999).CGColor;
    self.containerView.layer.borderWidth = AD_1PX;
    self.containerView.layer.cornerRadius = 3;
    
    self.readmeIcon.image = [UIImage ad_normalImageWithIdentifier:@"Book" size:CGSizeMake(24, 24)];
    
    [self.activityIndicator startAnimating];
    
    self.separator1Height.constant = AD_1PX;
    self.separator2Height.constant = AD_1PX;
    
    self.webView.scrollView.scrollEnabled = NO;
    CGRect frame = self.webView.frame;
    frame.size.height = 1;
    self.webView.frame = frame;
}

@end
