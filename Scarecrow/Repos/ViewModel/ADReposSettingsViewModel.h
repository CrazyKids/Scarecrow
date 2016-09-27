//
//  ADReposSettingsViewModel.h
//  Scarecrow
//
//  Created by duanhongjin on 16/9/19.
//  Copyright © 2016年 duanhongjin. All rights reserved.
//

#import "ADTableViewModel.h"

typedef NS_ENUM(NSInteger, ADReposSettingData) {
    ADReposSettingDataOwner,
    ADReposSettingDataQRCode,
};

@interface ADReposSettingsViewModel : ADTableViewModel

@property (strong, nonatomic, readonly) OCTRepository *repos;

@end
