//
//  ADReposQRCodeViewModel.m
//  Scarecrow
//
//  Created by duanhongjin on 16/9/21.
//  Copyright © 2016年 duanhongjin. All rights reserved.
//

#import "ADReposQRCodeViewModel.h"
#import "NSURL+Scarecrow.h"
#import "OCTRepository+Persistence.h"

@interface ADReposQRCodeViewModel ()

@property (strong, nonatomic) OCTRepository *repos;

@property (strong, nonatomic) NSURL *avatarURL;
@property (strong, nonatomic) NSString *owner;
@property (strong, nonatomic) NSString *detail;
@property (strong, nonatomic) NSString *qrCode;

@property (strong, nonatomic) UIImage *qrImage;

@end

@implementation ADReposQRCodeViewModel

@dynamic avatarURL, owner, detail, qrCode, qrImage;

- (instancetype)initWithParam:(NSDictionary *)param {
    self = [super initWithParam:param];
    if (self) {
        self.repos = param[@"repos"];
    }
    return self;
}

- (void)initialize {
    [super initialize];
    
    self.title = @"Repos QR Code Info";
    
    RAC(self, avatarURL) = RACObserve(self.repos, ownerAvatarURL);
    
    self.owner = self.repos.ownerLogin;
    self.detail = self.repos.name;
    self.qrCode = [self.repos ad_url].absoluteString;
    self.qrImage = [UIImage imageNamed:@"welcomeIcon"];
}

@end
