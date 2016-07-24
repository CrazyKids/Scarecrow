//
//  NSMutableAttributedString+Scarecrow.h
//  Scarecrow
//
//  Created by duanhongjin on 8/5/16.
//  Copyright © 2016 duanhongjin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Scarecrow)

- (NSMutableAttributedString *)ad_attributedString;

@end

@interface NSMutableAttributedString (Scarecrow)

// Font
- (NSMutableAttributedString *)ad_addOctionFontAttribute;
- (NSMutableAttributedString *)ad_addNormalTitleFontAttribute;
- (NSMutableAttributedString *)ad_addBoldTitleFontAttribute;
- (NSMutableAttributedString *)ad_addTimeFontAttribute;
- (NSMutableAttributedString *)ad_addNormalPullInfoFontAttribute;
- (NSMutableAttributedString *)ad_addBoldPullInfoFontAttribute;

// Foreground Color
- (NSMutableAttributedString *)ad_addTimeForegroundColorAttribute;
- (NSMutableAttributedString *)ad_addNormalTitleForegroundColorAttribute;
- (NSMutableAttributedString *)ad_addBoldTitleForegroundColorAttribute;
- (NSMutableAttributedString *)ad_addPullInfoForegroundColorAttribute;
- (NSMutableAttributedString *)ad_addTintedForegroundColorAttribute;

// Background Color
- (NSMutableAttributedString *)ad_addBackgroundColorAttribute;

// Paragraph Style

- (NSMutableAttributedString *)ad_addParagraphStyleAttribute;

// Link
- (NSMutableAttributedString *)ad_addUserLinkAttribute;
- (NSMutableAttributedString *)ad_addReposLinkAttributeWithName:(NSString *)name referName:(NSString *)referName;
- (NSMutableAttributedString *)ad_addHTMLURLAttribute:(NSURL *)url;

//High Light
- (NSMutableAttributedString *)ad_addHighLightAttribute;

- (NSMutableAttributedString *)ad_addOcticonAttribute;
- (NSMutableAttributedString *)ad_addNormalTitleAttribute;
- (NSMutableAttributedString *)ad_addBoldTitleAttribute;

@end
