//
//  UIView+Extension.m
//  Scarecrow
//
//  Created by VictorZhang on 28/09/2016.
//  Copyright © 2016 duanhongjin. All rights reserved.
//

#import "UIView+Extension.h"

@implementation UIView (Extension)

- (UIImage *)snapshotImageWithSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:YES];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
