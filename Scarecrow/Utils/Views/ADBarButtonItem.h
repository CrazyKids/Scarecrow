//
//  ADBarButtonItem.h
//  Scarecrow
//
//  Created by duanhongjin on 9/19/16.
//  Copyright © 2016 duanhongjin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ADBarButtonPosition) {
    ADBarButtonLeft,
    ADBarButtonBack,
    ADBarButtonRight,
};

@interface ADBarButtonItem : UIBarButtonItem

- (instancetype)initWithTitle:(NSString *)title position:(ADBarButtonPosition)position style:(UIBarButtonItemStyle)style barColor:(UIColor *)barColor target:(id)target action:(SEL)action;

@end
