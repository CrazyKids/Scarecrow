//
//  ADReposQRCodeViewModel.m
//  Scarecrow
//
//  Created by duanhongjin on 16/9/21.
//  Copyright © 2016年 duanhongjin. All rights reserved.
//

#import "ADReposQRCodeViewModel.h"
#import "NSURL+Scarecrow.h"

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
    
    self.avatarURL = self.repos.ownerAvatarURL;
    self.owner = self.repos.ownerLogin;
    self.detail = self.repos.name;
//    self.qrCode = [NSURL ad_reposLink:[NSString stringWithFormat:@"%@/%@", self.repos.ownerLogin, self.repos.name] referName:nil].absoluteString;
    self.qrCode = self.repos.HTMLURL.absoluteString;
    self.qrImage = [UIImage imageNamed:@"welcomeIcon"];
}

@end
