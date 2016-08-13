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
    [[viewModel rac_signalForSelector:@selector(init)] subscribeNext:^(id x) {
        @strongify(viewModel);
        [viewModel initialize];
    }];
    
    return viewModel;
}

- (void)initialize {
    
}

- (RACSubject *)errors {
    if (!_errors) {
        _errors = [RACSubject subject];
    }
    return _errors;
}

@end
