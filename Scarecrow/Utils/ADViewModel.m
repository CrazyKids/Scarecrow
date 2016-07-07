//
//  ADViewModel.m
//  Scarecrow
//
//  Created by duanhongjin on 7/7/16.
//  Copyright © 2016 duanhongjin. All rights reserved.
//

#import "ADViewModel.h"

@implementation ADViewModel

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    ADViewModel *viewModel = [super allocWithZone:zone];
    
    @weakify(viewModel)
    [[viewModel rac_signalForSelector:@selector(init)] subscribeNext:^(id x) {
        @strongify(viewModel)
        [viewModel initialize];
    }];
    
    return viewModel;
}

- (void)initialize {
    
}

@end
