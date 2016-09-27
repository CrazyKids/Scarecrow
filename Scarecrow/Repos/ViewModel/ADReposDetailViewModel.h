//
//  ADReposDetailViewModel.h
//  Scarecrow
//
//  Created by duanhongjin on 16/9/11.
//  Copyright © 2016年 duanhongjin. All rights reserved.
//

#import "ADTableViewModel.h"

typedef NS_ENUM(NSInteger, ADReposDetailData) {
    ADReposDetailDataDesc,
    ADReposDetailDataStatistics,
    ADReposDetailDataViewCode,
    ADReposDetailDataReadme,
};

@interface ADReposDetailViewModel : ADTableViewModel

@property (strong, nonatomic, readonly) OCTRepository *repos;

@property (strong, nonatomic, readonly) OCTRef *reference;

@property (strong, nonatomic, readonly) NSString *dateUpdated;
@property (strong, nonatomic, readonly) NSString *readmeHTML;

@property (strong, nonatomic, readonly) RACCommand *viewCodeCommand;
@property (strong, nonatomic, readonly) RACCommand *viewReadmeCommand;
@property (strong, nonatomic, readonly) RACCommand *changeBranchCommand;
@property (strong, nonatomic, readonly) RACCommand *rightBarButtonCommand;

@end
