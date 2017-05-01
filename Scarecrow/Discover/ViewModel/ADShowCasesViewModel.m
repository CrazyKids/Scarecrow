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
#import "ADModelShowCase.h"
#import "ADShowCaseItemViewModel.h"
#import "ADShowCaseReposViewModel.h"

@implementation ADShowCasesViewModel

- (void)initialize {
    [super initialize];
    
    self.title = @"Show Cases";
    
    @weakify(self);
    self.didSelectCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(NSIndexPath *indexPath) {
        @strongify(self);
        
        ADShowCaseItemViewModel *viewModel = self.dataSourceArray[indexPath.section][indexPath.row];
        ADShowCaseReposViewModel *reposViewModel = [[ADShowCaseReposViewModel alloc]initWithParam:@{@"showCase" : viewModel.showCase}];
        
        [self pushViewControllerWithViewModel:reposViewModel];
        
        return [RACSignal empty];
    }];
    
    RACSignal *fetchLocalDataSignal = [RACSignal return:[self fetchLocalData]];
    RACSignal *fetchRemoteDataSignal = self.fetchRemoteDataCommamd.executionSignals.switchToLatest;;

    RAC(self, dataSourceArray) = [[fetchLocalDataSignal merge:fetchRemoteDataSignal] map:^id(NSArray *showCaseArray) {
        return [self dataSourceSignalWithShowCaseArray:showCaseArray];
    }];
}

- (id)fetchLocalData {
#ifdef DEBUG
    NSString *filePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"showCases.json"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    
    NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    NSError *error = nil;
    NSArray *showCases = [MTLJSONAdapter modelsOfClass:[ADModelShowCase class] fromJSONArray:array error:&error];
    
    return showCases;
#else
    return nil;
#endif
}

- (RACSignal *)fetchRemoteDataSignalWithPage:(int)page {    
    ADRepositoryService *service = [ADPlatformManager sharedInstance].service.reposService;
    
    return [service fetchShowCases];
}

- (NSArray *)dataSourceSignalWithShowCaseArray:(NSArray *)showCaseArray {
    if (showCaseArray.count == 0) {
        return nil;
    }
    
    NSArray *viewModelArray = [showCaseArray.rac_sequence map:^id(ADModelShowCase *showCase) {
        ADShowCaseItemViewModel *viewModel = [[ADShowCaseItemViewModel alloc]initWithShowCase:showCase];
        
        return viewModel;
    }].array;
    
    return @[viewModelArray ?: @[]];
}

@end
