//
//  ZRPopoverView+RACSignalSupport.m
//  Scarecrow
//
//  Created by duanhongjin on 2017/3/26.
//  Copyright © 2017年 duanhongjin. All rights reserved.
//

#import "ZRPopoverView+RACSignalSupport.h"
#import <objc/runtime.h>

@implementation ZRPopoverView (RACSignalSupport)

static void RACUseDelegateProxy(ZRPopoverView *self) {
    if (self.delegate == self.rac_delegateProxy) return;
    
    self.rac_delegateProxy.rac_proxiedDelegate = self.delegate;
    self.delegate = (id)self.rac_delegateProxy;
}

- (RACDelegateProxy *)rac_delegateProxy {
    RACDelegateProxy *proxy = objc_getAssociatedObject(self, _cmd);
    if (!proxy) {
        proxy = [[RACDelegateProxy alloc]initWithProtocol:@protocol(ZRPopoverViewDelegate)];
        objc_setAssociatedObject(self, _cmd, proxy, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return proxy;
}

- (RACSignal *)rac_buttonClickedSignal {
    RACSignal *signal = [[[[self.rac_delegateProxy signalForSelector:@selector(popoverView:didClick:)]
                         reduceEach:^(ZRPopoverView *popoverView, NSNumber *index){ return index;}]
                          takeUntil:self.rac_willDeallocSignal]
                         setNameWithFormat:@"%@ -rac_buttonClickedSignal", self.rac_description];
    
    RACUseDelegateProxy(self);
    
    return signal;
}

@end
