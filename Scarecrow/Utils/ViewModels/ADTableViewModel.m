//
//  ADTableViewModel.m
//  Scarecrow
//
//  Created by duanhongjin on 8/1/16.
//  Copyright © 2016 duanhongjin. All rights reserved.
//

#import "ADTableViewModel.h"

@interface ADTableViewModel ()

@property (strong, nonatomic) RACCommand *fetchRemoteDataCommamd;

@end

@implementation ADTableViewModel

- (void)initialize {
    [super initialize];
    
    self.page = 1;
    self.pageStep = 100;
    
    @weakify(self);
    self.fetchRemoteDataCommamd = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(NSNumber *page) {
        @strongify(self);
        
        return [self fetchRemoteDataSignalWithPage:page.intValue];
    }];
    
    [[self.fetchRemoteDataCommamd.errors filter:[self fetchRemoteDataError]]subscribe:self.errors];
}

- (RACSignal *)fetchRemoteDataSignalWithPage:(int)page {
    return [RACSignal empty];
}

- (BOOL (^)(NSError *error))fetchRemoteDataError {
    return ^(NSError *error) {
        return YES;
    };
}

- (id)fetchLocalData {
    return nil;
}

@end
