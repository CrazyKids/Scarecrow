//
//  ADLanguageViewModel.m
//  Scarecrow
//
//  Created by duanhongjin on 24/03/2017.
//  Copyright © 2017 duanhongjin. All rights reserved.
//

#import "ADLanguageViewModel.h"

@implementation ADLanguageViewModel

- (instancetype)initWithParam:(NSDictionary *)param {
    self = [super initWithParam:param];
    if (self) {
        self.currentLanguageDic = param[@"language"];
    }
    return self;
}

- (void)initialize {
    [super initialize];
    
    self.title = @"All Languages";
    
    self.bShouldFetchData = NO;
    self.bShouldPullToRefresh = NO;
    
    NSString *filePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Languages.json"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    
    self.dataSourceArray = @[[NSJSONSerialization JSONObjectWithData:data options:0 error:nil]];

    @weakify(self);
    self.didSelectCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(NSIndexPath *indexPath) {
        @strongify(self);
        
        self.currentLanguageDic = self.dataSourceArray[indexPath.section][indexPath.row];
        
        return [RACSignal empty];
    }];
}

@end
