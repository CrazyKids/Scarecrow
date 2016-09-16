//
//  ZRQRGenerateCode.h
//  ZRQRCodeViewController
//
//  Created by VictorZhang on 9/12/16.
//  Copyright © 2016 XiaoRuiGeGe. All rights reserved.
//
//  https://github.com/VictorZhang2014/ZRQRCodeViewController
//  An open source library for iOS in Objective-C that is being compatible with iOS 7.0 and later.
//  Its main function that QR Code Scanning framework that are easier to call.
//

#import <Foundation/Foundation.h>
#include <UIKit/UIKit.h>

@interface ZRQRGenerateCode : NSObject

/*
 * Generate QRCode
 * @param imageRect , which is what size(CGRect) you want
 * @param dataString, is data string which could wrap into QR Code image
 **/
- (UIImageView *)generateQuickResponseCodeWithFrame:(CGRect)imageRect dataString:(NSString *)dataString NS_AVAILABLE_IOS(7_0);

/*
 * Generate QRCode with a center icon
 * @param imageRect , which is what size(CGRect) you want
 * @param dataString, is data string which could wrap into QR Code image
 * @param image, which is center icon amidst of the image
 **/
- (UIImageView *)generateQuickResponseCodeWithFrame:(CGRect)imageRect dataString:(NSString *)dataString centerImage:(UIImage *)image NS_AVAILABLE_IOS(7_0);

/*
 * Generate QRCode with a center icon and image shadow
 * @param imageRect , which is what size(CGRect) you want
 * @param dataString, is data string which could wrap into QR Code image
 * @param image, which is center icon amidst of the image
 * @param needShadow, whether it needs shadow or not
 **/
- (UIImageView *)generateQuickResponseCodeWithFrame:(CGRect)imageRect dataString:(NSString *)dataString centerImage:(UIImage *)image needShadow:(BOOL)shadow NS_AVAILABLE_IOS(7_0);

@end
