//
//  UIImage+Octions.h
//  Scarecrow
//
//  Created by duanhongjin on 8/14/16.
//  Copyright © 2016 duanhongjin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Octions)

+ (UIImage *)ad_imageWithIcon:(NSString *)icon backgroundColor:(UIColor *)backgroundColor iconColor:(UIColor *)iconColor iconScale:(CGFloat)iconScale size:(CGSize)size;

+ (UIImage *)ad_normalImageWithIdentifier:(NSString *)identifier size:(CGSize)size;
+ (UIImage *)ad_highlightImageWithIdentifier:(NSString *)identifier size:(CGSize)size;


- (UIImageView *)blurImageWithSize:(CGSize)size NS_AVAILABLE_IOS(8_0);

@end
