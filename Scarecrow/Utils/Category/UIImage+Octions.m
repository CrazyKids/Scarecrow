//
//  UIImage+Octions.m
//  Scarecrow
//
//  Created by duanhongjin on 8/14/16.
//  Copyright © 2016 duanhongjin. All rights reserved.
//

#import "UIImage+Octions.h"
#import <OcticonsIOS/NSString+Octicons.h>

@implementation UIImage (Octions)

+ (UIImage *)ad_imageWithIcon:(NSString *)icon backgroundColor:(UIColor *)backgroundColor iconColor:(UIColor *)iconColor iconScale:(CGFloat)iconScale size:(CGSize)size {
    if ([UIScreen instancesRespondToSelector:@selector(scale)]) {
        UIGraphicsBeginImageContextWithOptions(size, NO, 0.0f);
    } else {
        UIGraphicsBeginImageContext(size);
    }

    UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, size.width, size.height)];
    [backgroundColor setFill];
    [path fill];
    
    float fontSize = (MIN(size.width, size.height)) * iconScale;
    CGRect textRect = CGRectMake(size.width/2-(fontSize/2)*1.2, size.height/2-fontSize/2, fontSize*1.2, fontSize);
    UIFont *font = [UIFont fontWithName:kOcticonsFamilyName size:fontSize];
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle defaultParagraphStyle].mutableCopy;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle, NSForegroundColorAttributeName:iconColor};
    
    NSString *text = [NSString octicon_iconStringForIconIdentifier:icon];
    [text drawInRect:textRect withAttributes:dic];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
