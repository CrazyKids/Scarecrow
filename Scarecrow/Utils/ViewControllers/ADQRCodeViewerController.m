//
//  ADQRCodeViewerController.m
//  Scarecrow
//
//  Created by Victor Zhang on 9/16/16.
//  Copyright © 2016 duanhongjin. All rights reserved.
//

#import "ADQRCodeViewerController.h"
#import "ADQRCodeViewModel.h"
#import <ZRQRCodeViewController/ZRQRCodeController.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIColor+Scarecrow.h"

@interface ADQRCodeViewerController ()

@property (strong, nonatomic, readonly) ADQRCodeViewModel *viewModel;

@property (weak, nonatomic) IBOutlet UIImageView *smallAvatar;
@property (weak, nonatomic) IBOutlet UILabel *ownerName;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UIView *mainView;

@end

@implementation ADQRCodeViewerController

@dynamic viewModel;

+ (ADViewController *)viewController {
    ADQRCodeViewerController *vc = [[ADQRCodeViewerController alloc] initWithNibName:@"ADQRCodeViewerController" bundle:nil];
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.smallAvatar sd_setImageWithURL:self.viewModel.avatarURL placeholderImage:[UIImage imageNamed:@"default_avatar"]];
    self.ownerName.text = self.viewModel.owner;
    self.detailLabel.text = self.viewModel.detail;
    
    CGRect rect0 = self.mainView.frame;
    CGRect rect = CGRectMake(10, 10, rect0.size.width - 20, rect0.size.height - 20);
    
    @weakify(self);
    [RACObserve(self.viewModel, qrImage) subscribeNext:^(UIImage *qrImage) {
        @strongify(self);
        UIImageView *qrImageView = [[[ZRQRCodeViewController alloc] init] generateQuickResponseCodeWithFrame:rect dataString:self.viewModel.qrCode centerImage:qrImage needShadow:YES];
        qrImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        [self.mainView addSubview:qrImageView];
    }];
}

@end
