//
//  ZRAudio.m
//  ZRQRCodeViewController
//
//  Created by Victor John on 7/9/16.
//  Copyright © 2016 XiaoRuiGeGe. All rights reserved.
//
//  https://github.com/VictorZhang2014/ZRQRCodeViewController
//  An open source library for iOS in Objective-C that is being compatible with iOS 7.0 and later.
//  Its main function that QR Code Scanning framework that are easier to call.
//

#import "ZRAudio.h"
#import <AudioToolbox/AudioToolbox.h>

@interface ZRAudio()
@property (nonatomic, strong) ZRCustomBundle *customBundle;

@property (nonatomic, assign) SystemSoundID systemSoundId;
@end

@implementation ZRAudio

- (ZRCustomBundle *)customBundle
{
    if (!_customBundle) {
        _customBundle = [[ZRCustomBundle alloc] initWithBundleName:@"ZRQRCode"];
    }
    return _customBundle;
}

- (SystemSoundID)getDictSystemSoundID:(NSString **)soundName
{
    *soundName = @"ZR_Scan_Success";
    NSDictionary *soundDictionary = [[NSDictionary alloc] init];
    SystemSoundID soundID = [soundDictionary[*soundName] unsignedIntValue];
    return soundID;
}

- (void)playSoundWhenScanSuccess
{
    NSString *soundName = [[NSString alloc] init];
    SystemSoundID soundID = [self getDictSystemSoundID:&soundName];
    if(!soundID){
        NSString *cafPath = [[NSBundle bundleWithPath:[self.customBundle getBundlePath]] pathForResource:soundName ofType:@".caf"];
        NSURL *url = [NSURL URLWithString:cafPath];
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)(url), &soundID);
        AudioServicesPlayAlertSound(soundID);
        self.systemSoundId = soundID;
    }
}

- (void)disposeSound
{
    AudioServicesDisposeSystemSoundID(self.systemSoundId);
}

@end


@interface ZRCustomBundle()
@property (nonatomic, copy) NSString *bundlePath;
@end

@implementation ZRCustomBundle

- (instancetype)initWithBundleName:(NSString *)bundleName
{
    if (self = [super init]) {
        _bundlePath = [[NSBundle mainBundle] pathForResource:bundleName ofType:@"bundle"];
    }
    return self;
}

- (NSString *)getBundlePath
{
    return self.bundlePath;
}

- (NSString *)getFileWithName:(NSString *)fileName
{
    return [self.bundlePath stringByAppendingPathComponent:fileName];
}

- (UIImage *)getImageWithName:(NSString *)imgName
{
    NSString *imgStr = [self.bundlePath stringByAppendingPathComponent:imgName];
    return [UIImage imageWithContentsOfFile:imgStr];
}

@end




