//
//  ADProfileViewModel.h
//  Scarecrow
//
//  Created by duanhongjin on 8/2/16.
//  Copyright © 2016 duanhongjin. All rights reserved.
//

#import "ADTableViewModel.h"

@class ADAvatarHeaderViewModel;

extern NSString* const kDefaultPlaceHolder;

typedef NS_ENUM(NSInteger, ADUserInfoDataType) {
    ADUserInfoDataTypeOrganization,
    ADUserInfoDataTypeLocation,
    ADUserInfoDataTypeMail,
    ADUserInfoDataTypeLink,
    ADUserInfoDataTypeName,
    ADUserInfoDataTypeStarred,
    ADUserInfoDataTypeActivity,
    ADUserInfoDataTypeGenerateQRCode
};

@interface ADProfileViewModel : ADTableViewModel

@property (strong, nonatomic) OCTUser *user;

@property (strong, nonatomic, readonly) NSString *compay;
@property (strong, nonatomic, readonly) NSString *location;
@property (strong, nonatomic, readonly) NSString *email;
@property (strong, nonatomic, readonly) NSString *blog;

@property (strong, nonatomic, readonly) ADAvatarHeaderViewModel *avatarHeaderViewModel;

@end
