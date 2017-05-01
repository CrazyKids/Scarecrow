//
//  UIImage+Scarecrow.h
//  Scarecrow
//
//  Created by duanhongjin on 8/14/16.
//  Copyright © 2016 duanhongjin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Scarecrow)

+ (UIImage *)ad_imageWithIcon:(NSString *)icon backgroundColor:(UIColor *)backgroundColor iconColor:(UIColor *)iconColor iconScale:(CGFloat)iconScale size:(CGSize)size;

+ (UIImage *)ad_normalImageWithIdentifier:(NSString *)identifier size:(CGSize)size;
+ (UIImage *)ad_highlightImageWithIdentifier:(NSString *)identifier size:(CGSize)size;


- (UIImageView *)ad_blurImageWithSize:(CGSize)size NS_AVAILABLE_IOS(8_0);

+ (UIImage *)ad_viewCapture:(UIView*)view;
+ (UIImage *)ad_screenCaptureWithRect:(CGRect)rect;
+ (UIImage *)ad_screenCapture;

@end
