//
//  ADLoginViewModel.h
//  Scarecrow
//
//  Created by duanhongjin on 16/7/7.
//  Copyright © 2016年 duanhongjin. All rights reserved.
//

#import "ADViewModel.h"

@interface ADLoginViewModel : ADViewModel

@property (strong, nonatomic, readonly) RACCommand *loginCommand;
@property (strong, nonatomic, readonly) RACCommand *exchangeTokenCommand;

@end
