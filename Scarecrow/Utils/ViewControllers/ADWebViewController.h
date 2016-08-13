//
//  ADWebViewController.h
//  Scarecrow
//
//  Created by duanhongjin on 8/12/16.
//  Copyright © 2016 duanhongjin. All rights reserved.
//

#import "ADViewController.h"

@interface ADWebViewController : ADViewController<UIWebViewDelegate>

@property (nonatomic, weak) IBOutlet UIWebView *webView;

@end
