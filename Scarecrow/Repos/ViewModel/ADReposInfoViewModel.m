//
//  ADReposInfoViewModel.m
//  Scarecrow
//
//  Created by duanhongjin on 16/9/19.
//  Copyright © 2016年 duanhongjin. All rights reserved.
//

#import "ADReposInfoViewModel.h"
#import "OCTRepository+Persistence.h"
#import "ADReposSettingsViewModel.h"

@interface ADReposInfoViewModel ()

@property (strong, nonatomic) OCTRepository *repos;
@property (strong, nonatomic) RACCommand *rightBarCommand;

@end

@implementation ADReposInfoViewModel

- (instancetype)initWithParam:(NSDictionary *)param {
    self = [super initWithParam:param];
    if (self) {
        id repos = param[@"repos"];
        if ([repos isKindOfClass:[OCTRepository class]]) {
            self.repos = repos;
        } else if ([repos isKindOfClass:[NSDictionary class]]) {
            self.repos = [OCTRepository modelWithDictionary:repos error:nil];
        }
    }
    return self;
}

- (void)initialize {
    [super initialize];
    
    self.request = [NSURLRequest requestWithURL:[self.repos ad_url]];
    
    @weakify(self);
    self.rightBarCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        
        ADReposSettingsViewModel *viewModel = [[ADReposSettingsViewModel alloc]initWithParam:@{@"repos" : self.repos}];
        [self pushViewControllerWithViewModel:viewModel];
        
        return [RACSignal empty];
    }];
}

@end
