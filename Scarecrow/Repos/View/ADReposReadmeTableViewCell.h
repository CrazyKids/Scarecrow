//
//  ADReposReadmeTableViewCell.h
//  Scarecrow
//
//  Created by duanhongjin on 9/12/16.
//  Copyright © 2016 duanhongjin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ADReposReadmeTableViewCell : UITableViewCell

@property (weak, nonatomic, readonly) UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic, readonly) UIWebView *webView;
@property (weak, nonatomic, readonly) UIButton *readmeButton;

@end
