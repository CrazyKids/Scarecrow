//
//  ADQRCodeViewerController.m
//  Scarecrow
//
//  Created by Victor Zhang on 9/16/16.
//  Copyright © 2016 duanhongjin. All rights reserved.
//

#import "ADQRCodeViewerController.h"
#import "ADQRCodeViewModel.h"
#import <ZRQRCodeController/ZRQRCodeController.h>
#import <WebImage/UIImageView+WebCache.h>
#import "UIColor+Scarecrow.h"
#import "UIImage+Scarecrow.h"

@interface ADQRCodeViewerController ()

@property (strong, nonatomic, readonly) ADQRCodeViewModel *viewModel;

@property (weak, nonatomic) IBOutlet UIImageView *smallAvatar;
@property (weak, nonatomic) IBOutlet UILabel *ownerName;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UIView *mainView;

@property (strong, nonatomic) UIImageView *qrImageView;

@end

@implementation ADQRCodeViewerController

@dynamic viewModel;

+ (ADViewController *)viewController {
    ADQRCodeViewerController *vc = [[ADQRCodeViewerController alloc] initWithNibName:@"ADQRCodeViewerController" bundle:nil];
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.smallAvatar.image = [UIImage imageNamed:@"default_avatar"];
    self.ownerName.text = self.viewModel.owner;
    self.detailLabel.text = self.viewModel.detail;
    
    @weakify(self);
    dispatch_async(dispatch_get_main_queue(), ^{
        @strongify(self);
        
        [[RACObserve(self.viewModel, qrImage) distinctUntilChanged] subscribeNext:^(UIImage *qrImage) {
            @strongify(self);
            
            CGRect rect0 = self.mainView.frame;
            CGFloat width = rect0.size.width;
            CGFloat height = rect0.size.height;
            if (width > height) {
                height -= 20;
                width = height;
            } else {
                width -= 20;
                height = width;
            }
            
            CGRect rect = CGRectMake((rect0.size.width - width) / 2.0, (rect0.size.height - height) / 2.0, width, height);
            
            UIImageView *qrImageView = [[[ZRQRCodeViewController alloc] init] generateQuickResponseCodeWithFrame:rect dataString:self.viewModel.qrCode centerImage:qrImage needShadow:YES];
            
            [self.qrImageView removeFromSuperview];
            self.qrImageView = qrImageView;
            
            [self.mainView addSubview:qrImageView];
        }];
    });
    
    [self addBlurImage];
}

- (void)addBlurImage
{
    if (!self.viewModel.snapshotLastVCViewImage) {
        return;
    }
    CGRect snapRect = [UIScreen mainScreen].bounds;
    UIImageView *snapImgView = [self.viewModel.snapshotLastVCViewImage blurImageWithSize:snapRect.size];
    [snapImgView setFrame:snapRect];
    [self.view insertSubview:snapImgView belowSubview:[self.view.subviews firstObject]];
}

- (void)bindViewModel {
    [super bindViewModel];
    
    @weakify(self);
    [[RACObserve(self.viewModel, avatarURL) distinctUntilChanged]subscribeNext:^(NSURL *avatarURL) {
        [[SDWebImageManager sharedManager]downloadImageWithURL:avatarURL options:SDWebImageRefreshCached progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            @strongify(self);
            if (image && finished) {
                self.smallAvatar.image = image;
            }
        }];
    }];
}

@end
