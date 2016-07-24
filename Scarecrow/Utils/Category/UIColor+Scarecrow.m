//
//  UIColor+Scarecrow.m
//  Scarecrow
//
//  Created by duanhongjin on 7/31/16.
//  Copyright © 2016 duanhongjin. All rights reserved.
//

#import "UIColor+Scarecrow.h"

@implementation UIColor (Scarecrow)

+ (UIColor *)colorWithRgbColor:(NSInteger)rgbColor alpha:(CGFloat)alpha {
    return [UIColor colorWithRed:((rgbColor & 0xFF0000) >> 16)/255.0 green:((rgbColor & 0xFF00) >> 8)/255.0 blue:((rgbColor & 0xFF)/255.0) alpha:alpha];
}

+ (UIColor *)NavigationBarColor {
    return [self colorWithRgbColor:0x479ADE alpha:1];
}

@end
