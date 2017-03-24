//
//  ADRepositoryService.h
//  Scarecrow
//
//  Created by duanhongjin on 24/03/2017.
//  Copyright © 2017 duanhongjin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ADRepositoryService : NSObject

- (RACSignal *)fetchTrendingRepositoriesWithSince:(NSString *)since language:(NSString *)language;

@end
