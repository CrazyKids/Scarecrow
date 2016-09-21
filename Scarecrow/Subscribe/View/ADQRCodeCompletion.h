//
//  ADQRCodeCompletion.h
//  Scarecrow
//
//  Created by duanhongjin on 16/9/22.
//  Copyright © 2016年 duanhongjin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ADQRCodeCompletion : NSObject

- (void)performQRCodeCompletion:(__kindof UIViewController *)viewController stringValue:(NSString *)strValue removeTopAfterSuccess:(void(^)())success;

@end
