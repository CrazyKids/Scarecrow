//
//  ADWebViewController.h
//  Scarecrow
//
//  Created by duanhongjin on 8/12/16.
//  Copyright © 2016 duanhongjin. All rights reserved.
//

#import "ADViewController.h"
#import <WebKit/WebKit.h>

@interface ADWebViewController : ADViewController<WKNavigationDelegate>

@property (strong, nonatomic) WKWebView *webView;

@end
