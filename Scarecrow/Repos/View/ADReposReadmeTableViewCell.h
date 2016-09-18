//
//  ADReposReadmeTableViewCell.h
//  Scarecrow
//
//  Created by duanhongjin on 9/18/16.
//  Copyright © 2016 duanhongjin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ADReposDetailViewModel;

@interface ADReposReadmeTableViewCell : UITableViewCell

@property (weak, nonatomic, readonly) UIWebView *webview;
@property (weak, nonatomic, readonly) UIActivityIndicatorView *activityIndicator;

- (void)bindViewModel:(ADReposDetailViewModel *)viewModel;
- (CGFloat)height;

@end
