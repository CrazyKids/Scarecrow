//
//  ADTabBarLoader.m
//  Scarecrow
//
//  Created by duanhongjin on 16/7/24.
//  Copyright © 2016年 duanhongjin. All rights reserved.
//

#import "ADTabBarLoader.h"

@interface ADTabBarLoader ()

@property (weak, nonatomic) IBOutlet UITabBarController *tabBarController;
@property (strong, nonatomic) IBInspectable NSString *tabBarItemNames;

@end

@implementation ADTabBarLoader

- (void)awakeFromNib {
    NSArray *array = [self.tabBarItemNames componentsSeparatedByString:@","];
    NSMutableArray *vcArray = [NSMutableArray new];
    for (NSString *name in array) {
        UIViewController *vc = [[UIStoryboard storyboardWithName:name bundle:nil] instantiateInitialViewController];
        [vcArray addObject:vc];
    }
    self.tabBarController.viewControllers = vcArray;
}

@end
