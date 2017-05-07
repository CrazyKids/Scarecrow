//
//  UIColor+Scarecrow.m
//  Scarecrow
//
//  Created by duanhongjin on 7/31/16.
//  Copyright © 2016 duanhongjin. All rights reserved.
//

#import "UIColor+Scarecrow.h"

@implementation UIColor (Scarecrow)

+ (UIColor *)ad_colorWithRgbColor:(NSInteger)rgbColor alpha:(CGFloat)alpha {
    return [UIColor colorWithRed:((rgbColor & 0xFF0000) >> 16)/255.0 green:((rgbColor & 0xFF00) >> 8)/255.0 blue:((rgbColor & 0xFF)/255.0) alpha:alpha];
}

+ (UIColor *)ad_navigationBarColor {
    return [[self class] ad_colorWithRgbColor:0x479ADE alpha:1];
}

+ (UIColor *)ad_bottomLineColor {
    return [[self class] ad_colorWithRgbColor:0 alpha:(0x1A / 100.0f)];
}

@end
