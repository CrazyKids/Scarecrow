//
//  ADReposDetailViewModel.m
//  Scarecrow
//
//  Created by duanhongjin on 16/9/11.
//  Copyright © 2016年 duanhongjin. All rights reserved.
//

#import "ADReposDetailViewModel.h"
#import "OCTRef+Scarecrow.h"
#import <FormatterKit/TTTTimeIntervalFormatter.h>
#import "OCTRepository+Persistence.h"
#import <Ono/Ono.h>

@interface ADReposDetailViewModel ()

@property (strong, nonatomic) OCTRepository *repos;
@property (strong, nonatomic) NSString *referenceName;

@property (strong, nonatomic) OCTRef *reference;

@property (strong, nonatomic) NSString *dateUpdated;
@property (strong, nonatomic) NSString *readmeHTML;

@property (strong, nonatomic) RACCommand *viewCodeCommand;
@property (strong, nonatomic) RACCommand *viewReadmeCommand;
@property (strong, nonatomic) RACCommand *changeBranchCommand;
@property (strong, nonatomic) RACCommand *rightBarButtonCommand;

@end

@implementation ADReposDetailViewModel

- (instancetype)initWithParam:(NSDictionary *)param {
    self = [super initWithParam:param];
    if (self) {
        id repos = param[@"repos"];
        if ([repos isKindOfClass:[OCTRepository class]]) {
            self.repos = repos;
        } else if ([repos isKindOfClass:[NSDictionary class]]) {
            self.repos = [OCTRepository modelWithDictionary:repos error:nil];
        }
        
        self.referenceName = param[@"referenceName"] ?: [OCTRef ad_referenceNameWithBranch:self.repos.defaultBranch];
    }
    return self;
}

- (void)initialize {
    [super initialize];
    
    self.title = self.repos.name;
    
    self.dataSourceArray = @[
                             @[@(ADReposDetailDataDesc)],
                             @[@(ADReposDetailDataStatistics)],
//                             @[@(ADReposDetailDataViewCode)],
//                             @[@(ADReposDetailDataReadme)],
                             ];
    
    self.reference = [[OCTRef alloc]initWithDictionary:@{@"name" : self.referenceName} error:nil];
 
    TTTTimeIntervalFormatter *timeFormatter = [TTTTimeIntervalFormatter new];
    timeFormatter.locale = [[NSLocale alloc]initWithLocaleIdentifier:@"en_US"];
    
    RAC(self, dateUpdated) = [[RACObserve(self, repos.dateUpdated)ignore:nil] map:^id(NSDate *dateUpdated) {
        NSString *dateString = [timeFormatter stringForTimeIntervalFromDate:[NSDate date] toDate:dateUpdated];
        return [NSString stringWithFormat:@"Updated %@", dateString];
    }];
    
    @weakify(self);

    RACSignal *fetchLocalDataSignal = [RACSignal return:[self fetchLocalData]];
    RACSignal *fetchRemoteDataSignal = [self.fetchRemoteDataCommamd.executionSignals switchToLatest];
    [[[fetchLocalDataSignal merge:fetchRemoteDataSignal]deliverOnMainThread]subscribeNext:^(OCTRepository *repos) {
        @strongify(self);
        
        [self willChangeValueForKey:@"repos"];
        
        repos.starStatus = self.repos.starStatus;
        [self.repos mergeValuesForKeysFromModel:repos];
        
        [self didChangeValueForKey:@"repos"];
    }];
    
    NSString *readme = (NSString *)[[ADPlatformManager sharedInstance].cacheMgr objectForKey:[self cachedKeyForReadmeWithMediaType:OCTClientMediaTypeHTML]];
    [self getReadmeHTML:readme];
}

- (NSString *)cachedKeyForReadmeWithMediaType:(OCTClientMediaType)type {
    return [NSString stringWithFormat:@"repos/%@/%@readme?ref=%@type=%@", self.repos.ownerLogin, self.repos.name, self.reference.name, @(type)];
}

- (id)fetchLocalData {
    return [OCTRepository ad_fetchFullRepos:self.repos];
}

- (RACSignal *)fetchRemoteDataSignalWithPage:(int)page {
    RACSignal *fetchReposSignal = [[ADPlatformManager sharedInstance].client fetchRepositoryWithName:self.repos.name owner:self.repos.ownerLogin];
    
    RACSignal *fetchReadmeSignal = [[ADPlatformManager sharedInstance].client fetchRepositoryReadme:self.repos reference:self.reference.name mediaType:OCTClientMediaTypeHTML];
    
    @weakify(self);
    return [[[[RACSignal combineLatest:@[fetchReposSignal, fetchReadmeSignal]]doNext:^(RACTuple *tuple) {
        @strongify(self);
        
        self.readmeHTML = [self getReadmeHTML:tuple.last];
        [[ADPlatformManager sharedInstance].cacheMgr setObject:tuple.last forKey:[self cachedKeyForReadmeWithMediaType:OCTClientMediaTypeHTML]];
        
    }]map:^id(RACTuple *tuple) {
        return tuple.first;
    }]doNext:^(OCTRepository *repos) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [repos ad_update];
        });
    }];
}

- (NSString *)getReadmeHTML:(NSString *)readme {
    __block NSString *ret = @"<style type=\"text/css\">body { font-family: \"Helvetica Neue\", Helvetica, \"Segoe UI\", Arial, freesans, sans-serif; }</style>";
    
    NSString *originRet = ret;
    
    NSError *error = nil;
    ONOXMLDocument *document = [ONOXMLDocument HTMLDocumentWithString:readme encoding:NSUTF8StringEncoding error:&error];
    if (error) {
        return nil;
    }
    
    [document enumerateElementsWithXPath:@"//article/*" usingBlock:^(ONOXMLElement *element, NSUInteger idx, BOOL *stop) {
        if (idx < 3) {
            ret = [ret stringByAppendingString:element.description];
        }
    }];
    
    if ([ret isEqualToString:originRet]) {
        [document enumerateElementsWithCSS:@"div#readme" usingBlock:^(ONOXMLElement *element, NSUInteger idx, BOOL *stop) {
            if (idx < 3) {
                ret = [ret stringByAppendingString:element.description];
            }
        }];
    }
    
    return ret;
}

@end
