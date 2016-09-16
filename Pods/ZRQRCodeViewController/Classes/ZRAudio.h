//
//  ZRAudio.h
//  ZRQRCodeViewController
//
//  Created by Victor John on 7/9/16.
//  Copyright © 2016 XiaoRuiGeGe. All rights reserved.
//
//  https://github.com/VictorZhang2014/ZRQRCodeViewController
//  An open source library for iOS in Objective-C that is being compatible with iOS 7.0 and later.
//  Its main function that QR Code Scanning framework that are easier to call.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ZRAudio : NSObject

- (void)playSoundWhenScanSuccess;

- (void)disposeSound;

@end


@interface ZRCustomBundle : NSObject

- (instancetype)initWithBundleName:(NSString *)bundleName;

- (NSString *)getBundlePath;

- (NSString *)getFileWithName:(NSString *)fileName;

- (UIImage *)getImageWithName:(NSString *)imgName;

@end
