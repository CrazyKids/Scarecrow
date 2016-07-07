//
//  ADViewController.m
//  Scarecrow
//
//  Created by duanhongjin on 7/7/16.
//  Copyright © 2016 duanhongjin. All rights reserved.
//

#import "ADViewController.h"

@interface ADViewController ()

@property (strong, nonatomic, readwrite) ADViewModel *viewModel;

@end

@implementation ADViewController

- (instancetype)initWithViewModel:(ADViewModel *)viewModel {
    self = [super init];
    if (self) {
        [self initializeWithViewMode:viewModel];
    }
    return self;
}

- (void)initializeWithViewMode:(ADViewModel *)viewModel {
    self.viewModel = viewModel;
    
    @weakify(self)
    [[self rac_signalForSelector:@selector(viewDidLoad)]subscribeNext:^(id x) {
        @strongify(self)
        [self bindViewModel];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)bindViewModel {
    
}

#pragma mark - Autorotate
- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

#pragma mark - Auto hidden keyboard
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    
    [self.view endEditing:YES];
}

@end
