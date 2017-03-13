//
//  NSMutableAttributedString+Scarecrow.m
//  Scarecrow
//
//  Created by duanhongjin on 8/5/16.
//  Copyright © 2016 duanhongjin. All rights reserved.
//

#import "NSMutableAttributedString+Scarecrow.h"
#import <Octicons/NSString+Octicons.h>
#import "UIColor+Scarecrow.h"
#import <YYKit/YYKit.h>
#import "NSURL+Scarecrow.h"

NSString *const kLinkAttributeKey = @"ADLinkAttributeKey";

@implementation NSString (Scarecrow)

- (NSMutableAttributedString *)ad_attributedString {
    return [[NSMutableAttributedString alloc]initWithString:self];
}

@end

@implementation NSMutableAttributedString (Scarecrow)

- (NSRange)ad_totalString {
    return NSMakeRange(0, self.length);
}

- (NSMutableAttributedString *)ad_addFontAttribute:(UIFont *)font {
    [self addAttribute:NSFontAttributeName value:font range:self.ad_totalString];
    
    return self;
}

- (NSMutableAttributedString *)ad_addOctionFontAttribute {
    return [self ad_addFontAttribute:[UIFont fontWithName:kOcticonsFamilyName size:16]];
}

- (NSMutableAttributedString *)ad_addNormalTitleFontAttribute {
    return [self ad_addFontAttribute:[UIFont systemFontOfSize:15]];
}

- (NSMutableAttributedString *)ad_addBoldTitleFontAttribute {
    return [self ad_addFontAttribute:[UIFont boldSystemFontOfSize:16]];
}

- (NSMutableAttributedString *)ad_addTimeFontAttribute {
    return [self ad_addFontAttribute:[UIFont systemFontOfSize:13]];
}

- (NSMutableAttributedString *)ad_addNormalPullInfoFontAttribute {
    return [self ad_addFontAttribute:[UIFont systemFontOfSize:12]];
}

- (NSMutableAttributedString *)ad_addBoldPullInfoFontAttribute {
    return [self ad_addFontAttribute:[UIFont boldSystemFontOfSize:12]];
}

- (NSMutableAttributedString *)ad_addForegroundColorAttribute:(NSInteger)rgbColor alpha:(CGFloat)alpha {
    UIColor *color = [UIColor colorWithRgbColor:rgbColor alpha:alpha];
    [self addAttribute:NSForegroundColorAttributeName value:color range:self.ad_totalString];
    
    return self;
}

- (NSMutableAttributedString *)ad_addTimeForegroundColorAttribute {
    return [self ad_addForegroundColorAttribute:0xbbbbbb alpha:1];
}

- (NSMutableAttributedString *)ad_addNormalTitleForegroundColorAttribute {
    return [self ad_addForegroundColorAttribute:0x666666 alpha:1];
}

- (NSMutableAttributedString *)ad_addBoldTitleForegroundColorAttribute {
    return [self ad_addForegroundColorAttribute:0x333333 alpha:1];
}

- (NSMutableAttributedString *)ad_addPullInfoForegroundColorAttribute {
    return [self ad_addForegroundColorAttribute:0 alpha:0.5f];
}

- (NSMutableAttributedString *)ad_addTintedForegroundColorAttribute {
    return [self ad_addForegroundColorAttribute:0x4078c0 alpha:1];
}

- (NSMutableAttributedString *)ad_addTintedForegroundColorAttributeWithAlpha:(CGFloat)alpha {
    return [self ad_addForegroundColorAttribute:0x4078c0 alpha:alpha];
}

- (NSMutableAttributedString *)ad_addParagraphStyleAttribute {
    if (self.length > 0) {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.paragraphSpacingBefore = 5;
        
        [self addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, MIN(2, self.length))];
    }
    return self;
}

- (NSMutableAttributedString *)ad_addUserLinkAttribute {
    [self addAttribute:kLinkAttributeKey value:[NSURL ad_userLink:self.string] range:self.ad_totalString];
    [self ad_addHighLightAttribute];
    
    return self;
}

- (NSMutableAttributedString *)ad_addReposLinkAttributeWithName:(NSString *)name referName:(NSString *)referName {
    
    [self addAttribute:kLinkAttributeKey value:[NSURL ad_reposLink:name referName:referName] range:self.ad_totalString];
    [self ad_addHighLightAttribute];
    
    return self;
}

- (NSMutableAttributedString *)ad_addHTMLURLAttribute:(NSURL *)url {
    [self addAttribute:kLinkAttributeKey value:url range:self.ad_totalString];
    [self ad_addHighLightAttribute];
    
    return self;
}

- (NSMutableAttributedString *)ad_addHighLightAttribute {
    YYTextBorder *highlightBorder = [YYTextBorder new];
    highlightBorder.insets = UIEdgeInsetsMake(-2, 0, -2, 0);
    highlightBorder.cornerRadius = 3;
    highlightBorder.fillColor = [UIColor colorWithRgbColor:0xD9D9D9 alpha:1];
    
    YYTextHighlight *highlight = [YYTextHighlight new];
    [highlight setBackgroundBorder:highlightBorder];
    
    [self setTextHighlight:highlight range:self.ad_totalString];
    
    return self;
}

- (NSMutableAttributedString *)ad_addOcticonAttribute {
    return [[self ad_addOctionFontAttribute]ad_addTimeForegroundColorAttribute];
}

- (NSMutableAttributedString *)ad_addNormalTitleAttribute {
    return [[self ad_addNormalTitleFontAttribute]ad_addNormalTitleForegroundColorAttribute];
}

- (NSMutableAttributedString *)ad_addBoldTitleAttribute {
    return [[self ad_addBoldTitleFontAttribute]ad_addBoldTitleForegroundColorAttribute];
}

@end
