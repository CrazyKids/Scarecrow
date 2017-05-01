//
//  ADShowCasesViewModel.m
//  Scarecrow
//
//  Created by duanhongjin on 2017/3/19.
//  Copyright © 2017年 duanhongjin. All rights reserved.
//

#import "ADShowCasesViewModel.h"
#import "ADViewModelService.h"
#import "ADRepositoryService.h"
#import "ADModelShowCases.h"
#import "ADShowCasesItemViewModel.h"

@implementation ADShowCasesViewModel

- (void)initialize {
    [super initialize];
    
    self.title = @"Show Cases";
    
    self.didSelectCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        return [RACSignal empty];
    }];
    
    RACSignal *fetchLocalDataSignal = [RACSignal return:[self fetchLocalData]];
    RACSignal *fetchRemoteDataSignal = self.fetchRemoteDataCommamd.executionSignals.switchToLatest;;

    RAC(self, dataSourceArray) = [fetchLocalDataSignal merge:fetchRemoteDataSignal];
}

- (id)fetchLocalData {
#ifdef DEBUG
    NSString *filePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"showCases.json"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    
    NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    NSError *error = nil;
    NSArray *showCases = [MTLJSONAdapter modelsOfClass:[ADModelShowCases class] fromJSONArray:array error:&error];
    
    NSArray *viewModelArray = [showCases.rac_sequence map:^id(ADModelShowCases *showCase) {
        ADShowCasesItemViewModel *viewModel = [[ADShowCasesItemViewModel alloc]initWithShowCase:showCase];
        
        return viewModel;
    }].array;
    
    return @[viewModelArray ?: @[]];
#else
    return nil;
#endif
}

- (RACSignal *)fetchRemoteDataSignalWithPage:(int)page {    
    ADRepositoryService *service = [ADPlatformManager sharedInstance].service.reposService;
    
    return [service fetchShowCases];
}

@end
