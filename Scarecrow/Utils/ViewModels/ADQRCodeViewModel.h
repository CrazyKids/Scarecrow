//
//  ADQRCodeModel.h
//  Scarecrow
//
//  Created by Victor Zhang on 9/16/16.
//  Copyright © 2016 duanhongjin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ADQRCodeViewModel : ADViewModel

@property (strong, nonatomic, readonly) NSURL *avatarURL;
@property (strong, nonatomic, readonly) NSString *owner;
@property (strong, nonatomic, readonly) NSString *detail;
@property (strong, nonatomic, readonly) NSString *qrCode;

@property (strong, nonatomic, readonly) UIImage *qrImage;

@property (nonatomic, strong) UIImage *snapshotLastVCViewImage;

@end
