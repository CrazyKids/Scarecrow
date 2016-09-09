//
//  ADSubscribeViewModel.m
//  Scarecrow
//
//  Created by duanhongjin on 16/7/24.
//  Copyright © 2016年 duanhongjin. All rights reserved.
//

#import "ADSubscribeViewModel.h"
#import "ADSubscribeItemViewModel.h"
#import "OCTEvent+Persistence.h"
#import "ADWebViewModel.h"
#import "NSURL+Scarecrow.h"
#import "ADUserInfoViewModel.h"
#import "OCTEvent+Persistence.h"


static NSString *const kSubscribeETag = @"subscribe_subscribe_etag";

@interface ADSubscribeViewModel ()

@property (strong, nonatomic) NSArray *eventArray;
@property (assign, nonatomic) BOOL isCurrentUser;
@property (strong, nonatomic) RACCommand *didClickLinkCommand;

@end

@implementation ADSubscribeViewModel

- (void)initialize {
    [super initialize];
    
    self.isCurrentUser = YES;
    
    @weakify(self);
    RAC(self, eventArray) = [[self.fetchRemoteDataCommamd.executionSignals.switchToLatest startWith:self.fetchLocalData]map:^id(NSArray *eventArray) {
        @strongify(self);
        if (!self.dataSourceArray) {
            return eventArray;
        }
        return [eventArray.rac_sequence takeUntilBlock:^BOOL(OCTEvent *event) {
            @strongify(self);
            ADSubscribeItemViewModel *viewModel = [self.dataSourceArray.firstObject firstObject];
            return [viewModel.event.objectID isEqualToString:event.objectID];
        }].array;
    }];
    
    if (self.isCurrentUser) {
        [[[RACObserve(self, dataSourceArray)ignore:nil]deliverOn:[RACScheduler scheduler]]subscribeNext:^(NSArray *dataSourceArray) {
            NSArray *eventArray = [[dataSourceArray.firstObject rac_sequence]map:^id(ADSubscribeItemViewModel *itemViewModel) {
                return itemViewModel.event;
            }].array;
            
            [OCTEvent ad_saveUserReceivedEvents:eventArray];
        }];
    }
    
    self.didClickLinkCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(NSURL *url) {
        @strongify(self);
        ADViewModel *viewModel = nil;
        if (url.linkType == ADLinkTypeUser) {
            ADUserInfoViewModel *userInfoModel = [[ADUserInfoViewModel alloc]initWithParam:[url ad_dic]];
            viewModel = userInfoModel;
        } else if (url.linkType == ADLinkTypeRepos) {
            
        } else {
            ADWebViewModel *webModel = [ADWebViewModel new];
            webModel.request = [NSURLRequest requestWithURL:url];
            viewModel = webModel;
        }
        
        [self pushViewControllerWithViewModel:viewModel];
        
        return [RACSignal empty];
    }];
    
    self.didSelectCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(NSIndexPath *indexPath) {
        @strongify(self);
        
        NSArray *array = self.dataSourceArray[indexPath.section];
        if (!array) {
            return [RACSignal empty];
        }
        
        ADSubscribeItemViewModel *viewModel = array[indexPath.row];
        return [self.didClickLinkCommand execute:viewModel.event.ad_link];
    }];
}

- (BOOL (^)(NSError *error))fetchRemoteDataError {
    return ^(NSError *error) {
        if ([error.domain isEqualToString:OCTClientErrorDomain] && error.code == OCTClientErrorServiceRequestFailed) {
            NSLog(@"%@", error);
            return NO;
        }
        return YES;
    };
}

- (id)fetchLocalData {
    NSArray *eventArray = nil;
    
    eventArray = [[OCTEvent ad_fetchUserReceivedEvents].rac_sequence take:500].array;
    
    return eventArray;
}

- (RACSignal *)fetchRemoteDataSignalWithPage:(int)page {
    RACSignal *fetchSignal = [RACSignal empty];
    
    NSString *etag = nil;
    if (self.isCurrentUser) {
        etag = [[NSUserDefaults standardUserDefaults]stringForKey:kSubscribeETag];
    }
    
    fetchSignal = [[ADPlatformManager sharedInstance].client fetchUserEventsNotMatchingEtag:etag];
    
    return [[[fetchSignal collect]doNext:^(NSArray *responseArray) {
        if (responseArray.count && self.isCurrentUser) {
            [[NSUserDefaults standardUserDefaults]setValue:[responseArray.firstObject etag] forKey:kSubscribeETag];
            [[NSUserDefaults standardUserDefaults]synchronize];
        }
    }]map:^id(NSArray *responseArray) {
        return [responseArray.rac_sequence map:^id(OCTResponse *response) {
            return response.parsedResult;
        }].array;
    }];
}

- (NSArray *)dataSourceWithEvents:(NSArray *)eventArray {
    if (!eventArray.count) {
        return nil;
    }
    
    NSArray *viewModelArry = [eventArray.rac_sequence map:^id(OCTEvent *event) {
        ADSubscribeItemViewModel *viewModel = [[ADSubscribeItemViewModel alloc]initWithEvent:event];
        return viewModel;
    }].array;
    
    return @[viewModelArry];
}

@end
