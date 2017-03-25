//
//  ADCountriesViewModel.m
//  Scarecrow
//
//  Created by duanhongjin on 2017/3/26.
//  Copyright © 2017年 duanhongjin. All rights reserved.
//

#import "ADCountriesViewModel.h"

@interface ADCountriesViewModel ()

@property (strong, nonatomic) NSDictionary *currentCountry;

@end

@implementation ADCountriesViewModel

- (instancetype)initWithParam:(NSDictionary *)param {
    self = [super initWithParam:param];
    if (self) {
        self.currentCountry = param[@"country"];
    }
    
    return self;
}

- (void)initialize {
    [super initialize];
    
    self.title = @"All Countries";
    
    self.bShouldFetchData = NO;
    self.bShouldPullToRefresh = NO;
    
    NSString *filePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Countries.json"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    
    self.dataSourceArray = @[[NSJSONSerialization JSONObjectWithData:data options:0 error:nil]];
    
    @weakify(self);
    self.didSelectCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(NSIndexPath *indexPath) {
        @strongify(self);
        
        self.currentCountry = self.dataSourceArray[indexPath.section][indexPath.row];
        
        return [RACSignal empty];
    }];
}

@end
