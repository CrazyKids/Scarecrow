//
//  ADRepositoryService.m
//  Scarecrow
//
//  Created by duanhongjin on 24/03/2017.
//  Copyright © 2017 duanhongjin. All rights reserved.
//

#import "ADRepositoryService.h"
#import <MKNetworkKit/MKNetworkKit.h>
#import "ADModelShowCases.h"
#import "ADShowCasesItemViewModel.h"

@implementation ADRepositoryService

- (RACSignal *)fetchTrendingRepositoriesWithSince:(NSString *)since language:(NSString *)language {
    since = since ?: @"";
    language = language ?: @"";
    
    return [[[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSString *URLString = [NSString stringWithFormat:@"http://trending.codehub-app.com/v2/trending?since=%@&language=%@", since, language];
        URLString = [URLString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        
        MKNetworkEngine *engine = [[MKNetworkEngine alloc]init];
        MKNetworkOperation *operation = [engine operationWithURLString:URLString];
        [operation addCompletionHandler:^(MKNetworkOperation *completedOperation) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSArray *array = completedOperation.responseJSON;
                if (array.count > 0) {
                    NSError *error = nil;
                    NSArray *repositories = [MTLJSONAdapter modelsOfClass:[OCTRepository class] fromJSONArray:array error:&error];
                    
                    if (!error) {
                        [subscriber sendNext:repositories];
                    }
                }
                [subscriber sendCompleted];
            });
        } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [subscriber sendError:error];
            });
        }];
        
        [engine enqueueOperation:operation];
        
        return [RACDisposable disposableWithBlock:^{
            [operation cancel];
        }];
    }]replayLazily]doNext:^(NSArray *repositories) {
    }] setNameWithFormat:@"-fetchTrendingRepositoriesWithSince:%@ language:%@", since, language];
}

- (RACSignal *)fetchShowCases {
    return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSString *urlString = @"http://trending.codehub-app.com/v2/showcases";
        
        MKNetworkEngine *engine = [[MKNetworkEngine alloc]init];
        MKNetworkOperation *operation = [engine operationWithURLString:urlString];
        [operation addCompletionHandler:^(MKNetworkOperation *completedOperation) {
            NSArray *array = completedOperation.responseJSON;
            if (array.count > 0) {
                NSError *error = nil;
                NSArray *showCases = [MTLJSONAdapter modelsOfClass:[ADModelShowCases class] fromJSONArray:array error:&error];
                
                if (!error) {
                    NSArray *viewModelArray = [showCases.rac_sequence map:^id(ADModelShowCases *showCase) {
                        ADShowCasesItemViewModel *viewModel = [[ADShowCasesItemViewModel alloc]initWithShowCase:showCase];
                        
                        return viewModel;
                    }].array;
                    
                    [subscriber sendNext:@[viewModelArray ?: @[]]];
                }
            }
            [subscriber sendCompleted];
        } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
            [subscriber sendError:error];
        }];
        
        [engine enqueueOperation:operation];
        
        return [RACDisposable disposableWithBlock:^{
            [operation cancel];
        }];
    }]replayLazily];
}

- (RACSignal *)fetchShowCasesReposWithSlug:(NSString *)slug {
    return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSString *urlString = [NSString stringWithFormat:@"http://trending.codehub-app.com/v2/showcases/%@", slug];
        
        MKNetworkEngine *engine = [[MKNetworkEngine alloc]init];
        MKNetworkOperation *operation = [engine operationWithURLString:urlString];
        [operation addCompletionHandler:^(MKNetworkOperation *completedOperation) {
            NSArray *array = completedOperation.responseJSON;
            if (array.count > 0) {
                NSError *error = nil;
                NSArray *repositories = [MTLJSONAdapter modelsOfClass:[OCTRepository class] fromJSONArray:array error:&error];
                
                if (!error) {
                    [subscriber sendNext:repositories];
                }
            }
            [subscriber sendCompleted];
        } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
            [subscriber sendError:error];
        }];
        
        [engine enqueueOperation:operation];
        
        return [RACDisposable disposableWithBlock:^{
            [operation cancel];
        }];
    }]replayLazily];
}

@end
