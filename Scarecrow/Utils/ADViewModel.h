//
//  ADViewModel.h
//  Scarecrow
//
//  Created by duanhongjin on 7/7/16.
//  Copyright © 2016 duanhongjin. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, ADTitleViewType) {
    ADTitleViewTypeDefault,
    ADTitleViewTypeLoading,
};

@interface ADViewModel : NSObject

@property (nonatomic, strong, readonly) RACSubject *errors;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) ADTitleViewType titleViewType;

- (void)initialize;

@end
