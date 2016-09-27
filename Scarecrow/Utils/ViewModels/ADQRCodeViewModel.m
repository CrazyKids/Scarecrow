//
//  ADQRCodeModel.m
//  Scarecrow
//
//  Created by Victor Zhang on 9/16/16.
//  Copyright © 2016 duanhongjin. All rights reserved.
//

#import "ADQRCodeViewModel.h"
#import "OCTUser+Persistence.h"

@interface ADQRCodeViewModel ()

@property (strong, nonatomic) NSURL *avatarURL;
@property (strong, nonatomic) NSString *owner;
@property (strong, nonatomic) NSString *detail;
@property (strong, nonatomic) NSString *qrCode;

@property (strong, nonatomic) UIImage *qrImage;

@end

@implementation ADQRCodeViewModel

- (void)initialize {
    [super initialize];
    
    self.avatarURL = [NSURL URLWithString:@"https://avatars2.githubusercontent.com/u/22089403?v=3&s=200"];
    self.owner = @"CrazyKids";
    self.detail = @"Scarecrow";
    self.qrCode = @"https://github.com/CrazyKids/Scarecrow";
    self.qrImage = [UIImage imageNamed:@"default_avatar"];
}

@end
