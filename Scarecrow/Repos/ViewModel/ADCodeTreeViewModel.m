//
//  ADCodeTreeViewModel.m
//  Scarecrow
//
//  Created by duanhongjin on 9/18/16.
//  Copyright © 2016 duanhongjin. All rights reserved.
//

#import "ADCodeTreeViewModel.h"

@interface ADCodeTreeViewModel ()

@property (strong, nonatomic) OCTRepository *repos;
@property (strong, nonatomic) OCTRef *reference;

@property (strong, nonatomic) OCTTree *tree;
@property (strong, nonatomic) NSString *path;

@end

@implementation ADCodeTreeViewModel

- (instancetype)initWithParam:(NSDictionary *)param {
    self = [super initWithParam:param];
    if (self) {
        self.repos = param[@"repos"];
        self.reference = param[@"reference"];
        self.tree = param[@"tree"];
        self.path = param[@"path"];
    }
    return self;
}

- (void)initialize {
    [super initialize];
    
    self.title = [NSString stringWithFormat:@"%@/%@", self.repos.ownerLogin, self.repos.name];

    self.bShouldPullToRefresh = self.path.length;
    
    RAC(self, tree) = self.fetchRemoteDataCommamd.executionSignals.switchToLatest;
    
    RAC(self, dataSourceArray) = [[RACObserve(self, tree) ignore:nil]map:^id(OCTTree *tree) {
        NSArray *array = [[tree.entries.rac_sequence filter:^BOOL(OCTTreeEntry *entry) {
            // 不展示submodule
            return entry.type != OCTTreeEntryTypeCommit;
        }]filter:^BOOL(OCTTreeEntry *entry) {
            if (self.path.length) {
                return [entry.path hasPrefix:[self.path stringByAppendingString:@"/"]] && [entry.path componentsSeparatedByString:@"/"].count == [self.path componentsSeparatedByString:@"/"].count + 1;
            }
            return [entry.path componentsSeparatedByString:@"/"].count == 1;
        }].array;
        
        [array sortedArrayUsingComparator:^NSComparisonResult(OCTTreeEntry *left, OCTTreeEntry *right) {
            if (left.type == right.type) {
                return [left.path compare:right.path options:NSCaseInsensitiveSearch];
            }
            
            return left.type == OCTTreeEntryTypeTree ? NSOrderedAscending : NSOrderedDescending;
        }];
        
        if (array.count == 0) {
            return nil;
        }
        
        return @[array];
    }];
    
    self.didSelectCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        
        return [RACSignal empty];
    }];
}

- (RACSignal *)fetchRemoteDataSignalWithPage:(int)page {
    if (self.path.length) {
        NSString *reference = [self.repos.name componentsSeparatedByString:@"/"].lastObject;
        return [[ADPlatformManager sharedInstance].client fetchTreeForReference:reference inRepository:self.repos recursive:YES];
    }
    
    return [RACSignal empty];
}

@end
