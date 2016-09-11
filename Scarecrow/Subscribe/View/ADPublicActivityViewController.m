//
//  ADPublicActivityViewController.m
//  Scarecrow
//
//  Created by duanhongjin on 16/9/10.
//  Copyright © 2016年 duanhongjin. All rights reserved.
//

#import "ADPublicActivityViewController.h"
#import "ADSubscribeTableViewCell.h"

@interface ADPublicActivityViewController ()

@end

@implementation ADPublicActivityViewController

+ (ADViewController *)viewController {
    return [[ADPublicActivityViewController alloc]initWithNibName:@"ADPublicActivityViewController" bundle:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"Public Activity";
}

@end
