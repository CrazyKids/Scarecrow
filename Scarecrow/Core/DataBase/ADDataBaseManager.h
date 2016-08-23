//
//  ADDataBaseManager.h
//  Scarecrow
//
//  Created by duanhongjin on 8/25/16.
//  Copyright © 2016 duanhongjin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ADDataBase.h"

@interface ADDataBaseManager : NSObject

@property (strong, nonatomic, readonly) NSString *path;
@property (strong, nonatomic, readonly) ADDataBase *dataBase;

- (instancetype)initWithRawLogin:(NSString *)rawLogin;

@end
