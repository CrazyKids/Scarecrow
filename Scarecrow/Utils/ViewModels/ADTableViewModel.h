//
//  ADTableViewModel.h
//  Scarecrow
//
//  Created by duanhongjin on 8/1/16.
//  Copyright © 2016 duanhongjin. All rights reserved.
//

#import "ADViewModel.h"

@interface ADTableViewModel : ADViewModel

@property (strong, nonatomic) NSArray *dataSourceArray;

@property (assign, nonatomic) int page;
@property (assign, nonatomic) int pageStep;

@property (assign, nonatomic) BOOL bShouldFetchData;
@property (assign, nonatomic) BOOL bShouldPullToRefresh;
@property (strong, nonatomic) RACCommand *didSelectCommand;
@property (strong, nonatomic, readonly) RACCommand *fetchRemoteDataCommamd;

- (RACSignal *)fetchRemoteDataSignalWithPage:(int)page;
- (BOOL (^)(NSError *error))fetchRemoteDataError;
- (id)fetchLocalData;

- (NSUInteger)offsetForPage:(NSUInteger)page;

@end
