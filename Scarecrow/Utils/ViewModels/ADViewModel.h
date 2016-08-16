//
//  ADViewModel.h
//  Scarecrow
//
//  Created by duanhongjin on 7/7/16.
//  Copyright © 2016 duanhongjin. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ADViewController;

typedef NS_ENUM(NSInteger, ADTitleViewType) {
    ADTitleViewTypeDefault,
    ADTitleViewTypeLoading,
};

typedef void (^voidCallback_id)(id);

@interface ADViewModel : NSObject

@property (weak, nonatomic) UIViewController *ownerVC;

@property (strong, nonatomic, readonly) RACSubject *errors;
@property (assign, nonatomic) ADTitleViewType titleViewType;

@property (copy, nonatomic) NSString *title;

@property (copy, nonatomic) voidCallback_id callback;

- (void)initialize;

@end
