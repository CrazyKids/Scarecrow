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

@interface ADQRCodeViewerController ()

@property (strong, nonatomic, readonly) ADQRCodeViewModel *viewModel;

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation ADQRCodeViewerController

@dynamic viewModel;

+ (ADViewController *)viewController {
    ADQRCodeViewerController *vc = [[ADQRCodeViewerController alloc] initWithNibName:@"ADQRCodeViewerController" bundle:nil];
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    CGRect rect = CGRectMake(10, 10, [UIScreen mainScreen].bounds.size.width - 20, [UIScreen mainScreen].bounds.size.width - 20);
    UIImage *center = [UIImage imageNamed:@"centericon"];
    UIImageView *myImage = [[[ZRQRCodeViewController alloc] init] generateQuickResponseCodeWithFrame:rect dataString:@"https://www.baidu.com" centerImage:center needShadow:YES];
    ADQRCodeViewerController *viewer = [[ADQRCodeViewerController alloc] init];
    viewer.imageView = myImage;
    
    rect.origin.x = 10;
    rect.origin.y = (self.view.frame.size.height - rect.size.height) / 2;
    rect.size.width = rect.size.width - 20;
    self.imageView.frame = rect;
    [self.view addSubview:self.imageView];
    
    self.view.backgroundColor = [UIColor whiteColor];
}

@end
