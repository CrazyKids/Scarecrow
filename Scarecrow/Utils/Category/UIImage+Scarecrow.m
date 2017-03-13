//
//  UIImage+Scarecrow.m
//  Scarecrow
//
//  Created by duanhongjin on 8/14/16.
//  Copyright © 2016 duanhongjin. All rights reserved.
//

#import "UIImage+Scarecrow.h"
#import <Octicons/NSString+Octicons.h>
#import "UIColor+Scarecrow.h"

@implementation UIImage (Scarecrow)

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

+ (UIImage *)ad_normalImageWithIdentifier:(NSString *)identifier size:(CGSize)size {
    return [self ad_imageWithIcon:identifier backgroundColor:[UIColor clearColor] iconColor:RGB(0x666666) iconScale:1 size:size];
}

+ (UIImage *)ad_highlightImageWithIdentifier:(NSString *)identifier size:(CGSize)size {
    return [self ad_imageWithIcon:identifier backgroundColor:[UIColor clearColor] iconColor:DEFAULT_RGB iconScale:1 size:size];
}


- (UIImageView *)blurImageWithSize:(CGSize)size
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIImageView *imgView = [[UIImageView alloc] initWithImage:self];
    [imgView setFrame:rect];
    
    UIBlurEffect *beffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:beffect];
    effectView.frame = rect;
    effectView.alpha = 0.95f;
    [imgView addSubview:effectView];
    return imgView;
}

@end
