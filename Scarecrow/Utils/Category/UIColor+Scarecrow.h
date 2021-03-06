//
//  UIColor+Scarecrow.h
//  Scarecrow
//
//  Created by duanhongjin on 7/31/16.
//  Copyright © 2016 duanhongjin. All rights reserved.
//

#import <UIKit/UIKit.h>

#define RGB(rgbColor) [UIColor ad_colorWithRgbColor:rgbColor alpha:1]
#define DEFAULT_RGB RGB(0x479ADE)

@interface UIColor (Scarecrow)

+ (UIColor *)ad_colorWithRgbColor:(NSInteger)rgbColor alpha:(CGFloat)alpha;
+ (UIColor *)ad_navigationBarColor;
+ (UIColor *)ad_bottomLineColor;

@end
