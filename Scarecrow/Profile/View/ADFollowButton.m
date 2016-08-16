//
//  ADFollowButton.m
//  Scarecrow
//
//  Created by duanhongjin on 8/14/16.
//  Copyright © 2016 duanhongjin. All rights reserved.
//

#import "ADFollowButton.h"
#import "UIImage+Octions.h"
#import "UIColor+Scarecrow.h"

@interface ADFollowButton ()

@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) UIImage *selectedImage;

@end

@implementation ADFollowButton

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    CGSize size = CGSizeMake(16, 16);
    self.image = [UIImage ad_imageWithIcon:@"Person" backgroundColor:[UIColor clearColor] iconColor:[UIColor colorWithRgbColor:0xffffff alpha:1] iconScale:1 size:size];
    self.selectedImage = [UIImage ad_imageWithIcon:@"Person" backgroundColor:[UIColor clearColor] iconColor:[UIColor colorWithRgbColor:0x333333 alpha:1] iconScale:1 size:size];
}

- (void)setSelected:(BOOL)selected {
    super.selected = selected;
    
    if (selected) {
        [self setImage:self.selectedImage forState:UIControlStateNormal];
        [self setTitle:@"Unfollow" forState:UIControlStateNormal];
        [self setTitleColor:[UIColor colorWithRgbColor:0x333333 alpha:1] forState:UIControlStateNormal];
        
        self.backgroundColor = [UIColor colorWithRgbColor:0xeeeeee alpha:1];
    } else {
        [self setImage:self.image forState:UIControlStateNormal];
        [self setTitle:@"Follow" forState:UIControlStateNormal];
        [self setTitleColor:[UIColor colorWithRgbColor:0xffffff alpha:1] forState:UIControlStateNormal];
        
        self.backgroundColor = [UIColor colorWithRgbColor:0x569e3d alpha:1];
    }
}

@end
