//
//  ADSetttingsViewModel.h
//  Scarecrow
//
//  Created by duanhongjin on 8/19/16.
//  Copyright © 2016 duanhongjin. All rights reserved.
//

#import "ADTableViewModel.h"

@interface ADSetttingsViewModel : ADTableViewModel

@property (strong, nonatomic, readonly) RACCommand *logoutCommand;

@end
