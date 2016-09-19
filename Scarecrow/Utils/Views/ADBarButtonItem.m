//
//  ADBarButtonItem.m
//  Scarecrow
//
//  Created by duanhongjin on 9/19/16.
//  Copyright © 2016 duanhongjin. All rights reserved.
//

#import "ADBarButtonItem.h"

@implementation ADBarButtonItem

- (instancetype)initWithTitle:(NSString *)title position:(ADBarButtonPosition)position style:(UIBarButtonItemStyle)style barColor:(UIColor *)barColor target:(id)target action:(SEL)action {
    if (position == ADBarButtonBack) {
        UIButton *leftButton = [self backButtonWithTitle:title barColor:barColor target:target action:action];
        self = [super initWithCustomView:leftButton];
    } else {
        self = [super initWithTitle:title style:style target:target action:action];
    }
    return self;
}

- (UIButton *)backButtonWithTitle:(NSString *)title barColor:(UIColor *)barColor target:(id)target action:(SEL)action {
    UIFont *font = [UIFont systemFontOfSize:17];
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributesDic = @{NSFontAttributeName: font,
                                    NSParagraphStyleAttributeName: paragraph};
    
    CGSize maxSize = CGSizeMake(80, CGFLOAT_MAX);
    CGRect rect = [title boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attributesDic context:nil];
    
    UIButton *button = [UIButton new];
    button.frame = CGRectMake(0, 0, rect.size.width + 17, 20);
    button.titleLabel.font = font;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:barColor forState:UIControlStateNormal];
    
    UIImage *image = [UIImage imageNamed:@"btn_backarrow"];
    [button setImage:image forState:UIControlStateNormal];
    button.imageEdgeInsets = UIEdgeInsetsMake(0, -3, 0, 0);
    button.titleEdgeInsets = UIEdgeInsetsMake(0, 3, 0, 0);
    
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

@end
