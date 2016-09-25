//
//  ADPublicActivityViewModel.m
//  Scarecrow
//
//  Created by duanhongjin on 16/9/10.
//  Copyright © 2016年 duanhongjin. All rights reserved.
//

#import "ADPublicActivityViewModel.h"
#import "OCTEvent+Persistence.h"

static NSString *const kPublicActivityETag = @"public_activity_etag";

@implementation ADPublicActivityViewModel

- (instancetype)initWithParam:(NSDictionary *)param {
    self = [super initWithParam:param];
    if (self) {
        self.showLoading = YES;
    }
    return self;
}

- (id)fetchLocalData {
    if (self.isCurrentUser) {
        return [OCTEvent ad_fetchUserPerformedEvents];
    }
    
    return nil;
}

- (void)saveEvents:(NSArray *)eventArray {
    [OCTEvent ad_saveUserPerformedEvents:eventArray];
}

- (RACSignal *)fetchRemoteDataSignalWithPage:(int)page {
    RACSignal *fetchSignal = [RACSignal empty];
    
    NSString *etag = nil;
    if (self.isCurrentUser) {
        etag = [[NSUserDefaults standardUserDefaults]stringForKey:kPublicActivityETag];
    }
    
    fetchSignal = [[ADPlatformManager sharedInstance].client fetchPerformedEventsForUser:self.user notMatchingEtag:etag];
    
    return [[[fetchSignal collect]doNext:^(NSArray *responseArray) {
        if (responseArray.count && self.isCurrentUser) {
            [[NSUserDefaults standardUserDefaults]setValue:[responseArray.firstObject etag] forKey:kPublicActivityETag];
            [[NSUserDefaults standardUserDefaults]synchronize];
        }
    }]map:^id(NSArray *responseArray) {
        return [responseArray.rac_sequence map:^id(OCTResponse *response) {
            return response.parsedResult;
        }].array;
    }];
}

@end
