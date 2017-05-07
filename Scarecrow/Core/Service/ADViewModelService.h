//
//  ADViewModelService.h
//  Scarecrow
//
//  Created by duanhongjin on 24/03/2017.
//  Copyright © 2017 duanhongjin. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ADRepositoryService;

@interface ADViewModelService : NSObject

@property (strong, nonatomic, readonly) ADRepositoryService *reposService;

@end
