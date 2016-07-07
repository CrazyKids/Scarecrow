//
//  ADLoginAnimation.m
//  Scarecrow
//
//  Created by duanhongjin on 16/7/7.
//  Copyright © 2016年 duanhongjin. All rights reserved.
//

#import "ADLoginAnimation.h"

@implementation ADLoginAnimation

+ (void)logoImageViewAnimation:(UIImageView *)imageView {
    [UIView animateWithDuration:1.5 animations:^{
        imageView.transform = CGAffineTransformMakeTranslation(0, -100);
    }];
}

+ (void)loginItemAnimation:(UIView *)view delay:(NSTimeInterval)delay {
    view.hidden = YES;
    [UIView animateWithDuration:1.5 delay:delay options:UIViewAnimationOptionTransitionNone animations:^{
        view.hidden = NO;
        view.transform = CGAffineTransformMakeTranslation(0, -100);
    } completion:nil];
}

@end
