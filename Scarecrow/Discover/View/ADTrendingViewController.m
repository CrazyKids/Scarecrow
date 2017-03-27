//
//  ADTrendingViewController.m
//  Scarecrow
//
//  Created by duanhongjin on 2017/3/19.
//  Copyright © 2017年 duanhongjin. All rights reserved.
//

#import "ADTrendingViewController.h"
#import "ADTrendingViewModel.h"
#import "UIImage+Scarecrow.h"
#import <Masonry/Masonry.h>
#import "UIColor+Scarecrow.h"
#import "ADTrendingReposViewController.h"
#import "ADBarButtonItem.h"

@interface ADTrendingViewController ()

@property (strong, nonatomic) UISegmentedControl *segmentedControl;
@property (strong, nonatomic) UIViewController *currentViewController;
@property (strong, nonatomic, readonly) ADTrendingViewModel *viewModel;

@property (strong, nonatomic) UIView *contentView;

@end

@implementation ADTrendingViewController

@dynamic viewModel;

+ (ADViewController *)viewController {
    ADTrendingViewController *vc = [[ADTrendingViewController alloc]initWithNibName:@"ADTrendingViewController" bundle:nil];
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Right Bar Button
    UIImage *rightBarImage = [UIImage ad_highlightImageWithIdentifier:@"Gear" size:CGSizeMake(22, 22)];
    self.navigationItem.rightBarButtonItem = [[ADBarButtonItem alloc]initWithImage:rightBarImage style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.rightBarButtonItem.rac_command = self.viewModel.rightBarButtonCommand;
    
    // Content View
    self.contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 45, LAYOUT_DEFAULT_WIDTH, LAYOUT_DEFAULT_HEIGHT - 45)];
    [self.view addSubview:self.contentView];
    
    // Segment Control
    UIView *wrapView = self.segmentWrapView;
    
    self.segmentedControl = [[UISegmentedControl alloc]initWithItems:@[@"Daily", @"Weekly", @"Monthly"]];
    self.segmentedControl.tintColor = DEFAULT_RGB;
    self.segmentedControl.selectedSegmentIndex = 0;
    [wrapView addSubview:self.segmentedControl];
    
    [self.segmentedControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wrapView.mas_left).offset(10);
        make.right.equalTo(wrapView.mas_right).offset(-10);
        make.centerY.equalTo(wrapView);
        make.height.equalTo(@(29.0));
    }];
    
    ADPlatformManager *manager = [ADPlatformManager sharedInstance];
    ADViewController *dailyViewController = [manager viewControllerWithViewModel:(ADViewModel *)self.viewModel.dailyViewModel];
    ADViewController *weeklyViewController = [manager viewControllerWithViewModel:(ADViewModel *)self.viewModel.weeklyViewModel];
    ADViewController *monthlyViewController = [manager viewControllerWithViewModel:(ADViewModel *)self.viewModel.monthlyViewModel];
    
    NSArray *viewControllers = @[dailyViewController, weeklyViewController, monthlyViewController];
    
    for (UIViewController *viewController in viewControllers) {
        viewController.view.frame = self.contentView.bounds;
        [self addChildViewController:viewController];
    }
    
    self.currentViewController = dailyViewController;
    [self.contentView addSubview:dailyViewController.view];
    
    @weakify(self);
    [[self.segmentedControl
      rac_newSelectedSegmentIndexChannelWithNilValue:@0]
    	subscribeNext:^(NSNumber *selectedSegmentIndex) {
            @strongify(self);
            
            UIViewController *toViewController = viewControllers[selectedSegmentIndex.unsignedIntegerValue];
            
            [self transitionFromViewController:self.currentViewController
                              toViewController:toViewController
                                      duration:0
                                       options:0
                                    animations:NULL
                                    completion:^(BOOL finished) {
                                        @strongify(self);
                                        self.currentViewController = toViewController;
                                    }];
        }];
}

- (UIView *)segmentWrapView {
    UIView *wrapView = [UIView new];
    wrapView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:wrapView];
    
    __weak __typeof(self)weakSelf = self;
    [wrapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view.mas_left);
        make.right.equalTo(weakSelf.view.mas_right);
        make.top.equalTo(weakSelf.view.mas_top);
        make.height.equalTo(@(45.0));
    }];
    
    UIView *bottomLine = [UIView new];
    bottomLine.backgroundColor = [UIColor ad_bottomLineColor];
    [wrapView addSubview:bottomLine];
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wrapView.mas_left);
        make.right.equalTo(wrapView.mas_right);
        make.bottom.equalTo(wrapView.mas_bottom);
        make.height.equalTo(@(AD_1PX));
    }];
    
    return wrapView;
}

@end
