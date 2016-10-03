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
    BOOL snapshotRet = [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:NO];
    UIImage *image = nil;
    if (snapshotRet) {
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return image;
}

@end
