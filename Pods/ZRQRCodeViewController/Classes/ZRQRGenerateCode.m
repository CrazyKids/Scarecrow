//
//  ZRQRGenerateCode.m
//  ZRQRCodeViewController
//
//  Created by VictorZhang on 9/12/16.
//  Copyright © 2016 XiaoRuiGeGe. All rights reserved.
//
//  https://github.com/VictorZhang2014/ZRQRCodeViewController
//  An open source library for iOS in Objective-C that is being compatible with iOS 7.0 and later.
//  Its main function that QR Code Scanning framework that are easier to call.
//

#import "ZRQRGenerateCode.h"

@implementation ZRQRGenerateCode

#pragma mark - Generate QR Code
- (UIImageView *)generateQuickResponseCodeWithFrame:(CGRect)imageRect dataString:(NSString *)dataString
{
    NSAssert(dataString, @"`dataString` must be non-nil!");
    return [self generateQRCodeWithFrame:imageRect dataString:dataString];
}

- (UIImageView *)generateQuickResponseCodeWithFrame:(CGRect)imageRect dataString:(NSString *)dataString centerImage:(UIImage *)image
{
    NSAssert(dataString, @"`dataString` must be non-nil!");
    NSAssert(image, @"`image` must be non-nil!");
    
    UIImageView *myImage = [self generateQRCodeWithFrame:imageRect dataString:dataString];
    if (image) {
        [self addCenterImageWithOrigin:&myImage withWidth:80 centerImage:image];
    }
    return myImage;
}

- (UIImageView *)generateQuickResponseCodeWithFrame:(CGRect)imageRect dataString:(NSString *)dataString centerImage:(UIImage *)image needShadow:(BOOL)shadow
{
    UIImageView *myImage = [self generateQuickResponseCodeWithFrame:imageRect dataString:dataString centerImage:image];
    if (shadow) {
        [self addShadow:&myImage];
    }
    return myImage;
}

- (UIImageView *)generateQRCodeWithFrame:(CGRect)imageRect dataString:(NSString *)dataString
{
    UIImageView *myImage = [[UIImageView alloc] initWithFrame:imageRect];
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [filter setDefaults];
    NSData *data = [dataString dataUsingEncoding:NSUTF8StringEncoding];
    [filter setValue:data forKey:@"inputMessage"];
    CIImage *outputImage = [filter outputImage];
    myImage.image = [self createNonInterpolatedUIImageFormCIImage:outputImage withSize:myImage.frame.size.width];
    return myImage;
}

/*
 Whether if it needs shadow , convey 'YES' in this parameter
 */
- (void)addShadow:(UIImageView **)imgView
{
    (*imgView).layer.shadowOffset = CGSizeMake(4, 4);
    (*imgView).layer.shadowRadius = 2.0;
    (*imgView).layer.shadowOpacity = 0.5;
    (*imgView).layer.shadowColor = [UIColor blackColor].CGColor;
}

/*
 Whether if it needs center icon , convey `YES` in this parameter
 */
- (void)addCenterImageWithOrigin:(UIImageView **)imgView withWidth:(CGFloat)imgWidth centerImage:(UIImage *)centerImage
{
    CGSize size = (*imgView).frame.size;
    CGFloat cW = imgWidth;
    CGFloat cH = cW;
    CGFloat cX = (size.width - cW) / 2;
    CGFloat cY = (size.height - cH) / 2;
    UIImageView *centerImgView = [[UIImageView alloc] initWithFrame:CGRectMake(cX, cY, cW, cH)];
    [centerImgView setImage:centerImage];
    centerImgView.layer.masksToBounds = YES;
    centerImgView.layer.cornerRadius = 8.0;
    [*imgView addSubview:centerImgView];
}

/*
 Get Image of original size through `size`
 */
- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size {
    //Get original extent size
    CGRect extent = CGRectIntegral(image.extent);
    
    //Get its scale
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    //According to the scale scope to acquire bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    
    //Create bitmap ImageRef based on `image` and `extent`
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // Saveing bitmap to UIImage in memory
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}

@end
