//
//  ADUserQRCodeViewModel.m
//  Scarecrow
//
//  Created by duanhongjin on 16/9/20.
//  Copyright © 2016年 duanhongjin. All rights reserved.
//

#import "ADUserQRCodeViewModel.h"
#import "NSURL+Scarecrow.h"
#import <SDWebImage/SDWebImageManager.h>

@interface ADUserQRCodeViewModel ()

@property (strong, nonatomic) OCTUser *user;

@property (strong, nonatomic) NSURL *avatarURL;
@property (strong, nonatomic) NSString *owner;
@property (strong, nonatomic) NSString *detail;
@property (strong, nonatomic) NSString *qrCode;

@property (strong, nonatomic) UIImage *qrImage;

@end

@implementation ADUserQRCodeViewModel

@dynamic avatarURL, owner, detail, qrCode, qrImage;

- (instancetype)initWithParam:(NSDictionary *)param {
    self = [super initWithParam:param];
    if (self) {
        self.user = param[@"user"];
    }
    return self;
}

- (void)initialize {
    [super initialize];
    
    self.title = @"QR Code Info";
    self.owner = self.user.name;
    self.avatarURL = self.user.avatarURL;
    self.detail = self.user.HTMLURL.absoluteString;
//    self.qrCode = [NSURL ad_userLink:self.user.login].absoluteString;
    self.qrCode = self.user.HTMLURL.absoluteString;
    
    @weakify(self);
    if (self.avatarURL) {
        self.qrImage = nil;
        [[SDWebImageManager sharedManager]downloadImageWithURL:self.avatarURL options:SDWebImageRefreshCached progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            @strongify(self);
            if (image && finished) {
                self.qrImage = image;
            }
        }];
    }
}

@end
