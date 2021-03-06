//
//  ADViewModel.m
//  Scarecrow
//
//  Created by duanhongjin on 7/7/16.
//  Copyright © 2016 duanhongjin. All rights reserved.
//

#import "ADViewModel.h"

@interface ADViewModel ()

@property (strong, nonatomic) RACSubject *errors;

@end

@implementation ADViewModel

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    ADViewModel *viewModel = [super allocWithZone:zone];
    
    @weakify(viewModel);
    [[viewModel rac_signalForSelector:@selector(initWithParam:)] subscribeNext:^(id x) {
        @strongify(viewModel);
        [viewModel initialize];
    }];
    
    return viewModel;
}

- (instancetype)init {
    return [self initWithParam:nil];
}

- (instancetype)initWithParam:(NSDictionary *)param {
    self = [super init];
    if (self) {
        self.showLoading = YES;
    }
    return self;
}

- (void)initialize {
    
}

- (RACSubject *)errors {
    if (!_errors) {
        _errors = [RACSubject subject];
    }
    return _errors;
}

- (void)pushViewControllerWithViewModel:(ADViewModel *)viewModel {
    if (!viewModel) {
        return;
    }
    
    ADViewController *vc = [[ADPlatformManager sharedInstance]viewControllerWithViewModel:viewModel];
    if (!vc || !self.ownerVC.navigationController) {
        return;
    }
    
    [self.ownerVC.navigationController pushViewController:vc animated:YES];
}

- (void)presentViewControllerWithViewModel:(ADViewModel *)viewModel animated:(BOOL)animated {
    if (!viewModel) {
        return;
    }
    
    ADViewController *vc = [[ADPlatformManager sharedInstance]viewControllerWithViewModel:viewModel];
    if (!vc || !self.ownerVC.navigationController) {
        return;
    }
    
    [self.ownerVC.navigationController presentViewController:vc animated:animated completion:nil];
}

@end
