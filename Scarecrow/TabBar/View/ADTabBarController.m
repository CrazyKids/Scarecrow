//
//  ADTabBarController.m
//  Scarecrow
//
//  Created by duanhongjin on 16/7/24.
//  Copyright © 2016年 duanhongjin. All rights reserved.
//

#import "ADTabBarController.h"

@interface ADTabBarController ()

@property (strong, nonatomic) ADViewModel *viewModel;

@end

@implementation ADTabBarController

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    ADTabBarController *vc = [super allocWithZone:zone];
    
    @weakify(vc);
    [[vc rac_signalForSelector:@selector(viewDidLoad)]subscribeNext:^(id x) {
        @strongify(vc);
        [vc bindViewModel];
    }];
    
    return vc;
}

- (instancetype)initWithViewModel:(ADViewModel *)viewModel {
    self = [self init];
    if (self) {
        [self initializeWithViewMode:viewModel];
    }
    return self;
}

- (void)initializeWithViewMode:(ADViewModel *)viewModel {
    self.viewModel = viewModel;
}

- (void)bindViewModel {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

@end
