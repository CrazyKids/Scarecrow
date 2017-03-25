//
//  ZRPopoverView+RACSignalSupport.h
//  Scarecrow
//
//  Created by duanhongjin on 2017/3/26.
//  Copyright © 2017年 duanhongjin. All rights reserved.
//

#import <ZRPopView/ZRPopView.h>

@interface ZRPopoverView (RACSignalSupport)

/// A delegate proxy which will be set as the receiver's delegate when any of the
/// methods in this category are used.
@property (nonatomic, strong, readonly) RACDelegateProxy *rac_delegateProxy;

/// Creates a signal for button clicks on the receiver.
///
/// When this method is invoked, the `rac_delegateProxy` will become the
/// receiver's delegate. Any previous delegate will become the -[RACDelegateProxy
/// rac_proxiedDelegate], so that it receives any messages that the proxy doesn't
/// know how to handle. Setting the receiver's `delegate` afterward is
/// considered undefined behavior.
///
/// Returns a signal which will send the index of the specific button clicked.
/// The signal will complete when the receiver is deallocated.
- (RACSignal *)rac_buttonClickedSignal;

@end
