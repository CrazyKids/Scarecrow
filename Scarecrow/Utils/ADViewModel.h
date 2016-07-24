//
//  ADViewModel.h
//  Scarecrow
//
//  Created by duanhongjin on 7/7/16.
//  Copyright © 2016 duanhongjin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ADViewModel : NSObject

@property (nonatomic, strong, readonly) RACSubject *errors;

- (void)initialize;

@end
