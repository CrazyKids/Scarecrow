//
//  ADUserQRCodeViewModel.m
//  Scarecrow
//
//  Created by duanhongjin on 16/9/20.
//  Copyright © 2016年 duanhongjin. All rights reserved.
//

#import "ADUserQRCodeViewModel.h"
#import "NSURL+Scarecrow.h"
#import <WebImage/SDWebImageManager.h>

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
    
    RAC(self, avatarURL) = RACObserve(self.user, avatarURL);
    
    self.owner = self.user.name;
    
    NSString *userHTMLURL = self.user.HTMLURL.absoluteString;
    if (!userHTMLURL.length) {
        userHTMLURL = [NSString stringWithFormat:@"https://github.com/%@", self.owner];
    }
    
    self.detail = userHTMLURL;
    self.qrCode = userHTMLURL;
    
    @weakify(self);
    
    [[RACObserve(self, avatarURL) distinctUntilChanged] subscribeNext:^(NSURL *avatarURL) {
        [[SDWebImageManager sharedManager]downloadImageWithURL:avatarURL options:SDWebImageRefreshCached progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            @strongify(self);
            if (image && finished) {
                self.qrImage = image;
            }
        }];
    }];
}

@end
