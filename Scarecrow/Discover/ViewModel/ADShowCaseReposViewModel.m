//
//  ADShowCaseReposViewModel.m
//  Scarecrow
//
//  Created by duanhongjin on 2017/5/1.
//  Copyright © 2017年 duanhongjin. All rights reserved.
//

#import "ADShowCaseReposViewModel.h"
#import "ADModelShowCase.h"
#import "ADViewModelService.h"
#import "ADRepositoryService.h"

@interface ADShowCaseReposViewModel ()

@property (strong, nonatomic) ADModelShowCase *showCase;

@end

@implementation ADShowCaseReposViewModel

- (instancetype)initWithParam:(NSDictionary *)param {
    self = [super initWithParam:param];
    if (self) {
        self.showCase = param[@"showCase"];
    }
    return self;
}

- (void)initialize {
    [super initialize];
    
    self.title = self.showCase.name;
}

- (NSArray *)fetchLocalData {
    return nil;
}

- (RACSignal *)fetchRemoteDataSignalWithPage:(int)page {
    ADRepositoryService *service = [ADPlatformManager sharedInstance].service.reposService;
    
    return [service fetchShowCasesReposWithSlug:self.showCase.slug];
}

- (ADReposViewModelOptions)options {
    ADReposViewModelOptions option = ADReposViewModelOptionsShowOwnerLogin;
    
    return option;
}

@end
