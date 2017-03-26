//
//  ADPopularUsersViewController.m
//  Scarecrow
//
//  Created by duanhongjin on 2017/3/25.
//  Copyright © 2017年 duanhongjin. All rights reserved.
//

#import "ADPopularUsersViewController.h"
#import "ADPopularUsersViewModel.h"
#import "UIImage+Scarecrow.h"
#import <ZRPopView/ZRPopView.h>

@interface ADPopularUsersViewController () <ZRPopoverViewDelegate>

@property (strong, nonatomic, readonly) ADPopularUsersViewModel *viewModel;
@property (strong, nonatomic) ZRPopoverView *popoverView;

@end

@implementation ADPopularUsersViewController

@dynamic viewModel;

+ (ADViewController *)viewController {
    return [[ADPopularUsersViewController alloc]initWithNibName:@"ADPopularUsersViewController" bundle:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImage *image = [UIImage ad_normalImageWithIdentifier:@"Gear" size:CGSizeMake(22, 22)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(onRightBarButtonClicked:)];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self.popoverView dismiss:nil];
}

#pragma mark - Action

- (void)onRightBarButtonClicked:(id)sender {
    self.popoverView.delegate = nil;
    
    ZRPopoverView *popoverView = [[ZRPopoverView alloc]initWithStyle:ZRPopoverViewStyleLightContent menus:self.viewModel.popoverMenus position:ZRPopoverViewPositionRightOfTop];
    self.popoverView = popoverView;
    popoverView.delegate = self;
    
    [popoverView showWithController:self];
}

#pragma mark - ZRPopoverViewDelegate
- (void)popoverView:(ZRPopoverView * _Nullable)popoverView didClick:(int)index {
    [self.viewModel.popoverCommand execute:@(index)];
}

@end
