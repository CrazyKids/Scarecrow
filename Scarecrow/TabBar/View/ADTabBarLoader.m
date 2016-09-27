//
//  ADTabBarLoader.m
//  Scarecrow
//
//  Created by duanhongjin on 16/7/24.
//  Copyright © 2016年 duanhongjin. All rights reserved.
//

#import "ADTabBarLoader.h"
#import "ADTabBarController.h"

@interface ADTabBarLoader ()

@property (weak, nonatomic) IBOutlet ADTabBarController *tabBarController;
@property (strong, nonatomic) IBInspectable NSString *tabBarItemNames;

@end

@implementation ADTabBarLoader

- (void)awakeFromNib {
    [super awakeFromNib];
    
    NSArray *array = [self.tabBarItemNames componentsSeparatedByString:@","];
    NSMutableArray *vcArray = [NSMutableArray new];
    for (NSString *name in array) {
        NSString *modelName = [NSString stringWithFormat:@"AD%@ViewModel", name];
        Class modelClass = NSClassFromString(modelName);
        ADViewModel *model = [modelClass new];
        UIViewController *vc = [[UIStoryboard storyboardWithName:name bundle:nil] instantiateInitialViewControllerWithViewModel:model];
        [vcArray addObject:vc];
    }
    self.tabBarController.viewControllers = vcArray;
}

@end
