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

@property (nonatomic, strong) UIImageView *imageView;

@property (atomic, assign) BOOL isFirstLoad;

@property (weak, nonatomic) IBOutlet UIImageView *smallAvatar;
@property (weak, nonatomic) IBOutlet UILabel *ownerName;
@property (weak, nonatomic) IBOutlet UILabel *ownerHomepage;
@property (weak, nonatomic) IBOutlet UIView *mainView;




@end

@implementation ADQRCodeViewerController

@dynamic viewModel;

+ (ADViewController *)viewController {
    ADQRCodeViewerController *vc = [[ADQRCodeViewerController alloc] initWithNibName:@"ADQRCodeViewerController" bundle:nil];
    return vc;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (!self.isFirstLoad) {
        self.isFirstLoad = true;

        OCTUser *user = self.viewModel.user;
        NSString *qrcontent = [NSString stringWithFormat:@"%@/Scarecrow", user.HTMLURL.absoluteString];
        UIImageView *image = [[UIImageView alloc] init];
        [image sd_setImageWithURL:user.avatarURL];
        UIImage *iconImage = image.image;
        if (iconImage) {
            [self.smallAvatar setImage:iconImage];
            [self.ownerName setText:user.name];
            [self.ownerHomepage setText:user.HTMLURL.absoluteString];
            
            CGRect rect0 = self.mainView.frame;
            CGRect rect = CGRectMake(10, 10, rect0.size.width - 20, rect0.size.width - 20);
            UIImageView *myImage = [[[ZRQRCodeViewController alloc] init] generateQuickResponseCodeWithFrame:rect dataString:qrcontent centerImage:iconImage needShadow:YES];
            [self.mainView addSubview:myImage];
        }
    }
}

@end
