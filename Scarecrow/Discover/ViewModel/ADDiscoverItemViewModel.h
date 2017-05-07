//
//  ADDiscoverItemViewModel.h
//  Scarecrow
//
//  Created by duanhongjin on 17/03/2017.
//  Copyright © 2017 duanhongjin. All rights reserved.
//

#import "ADViewModel.h"

@interface ADDiscoverItemViewModel : ADViewModel

@property (copy, nonatomic, readonly) NSString *itemName;
@property (strong, nonatomic, readonly) UIImage *itemIcon;
@property (strong, nonatomic, readonly) RACCommand *itemCommand;

@end
