//
//  ADPopluarRepositoriesViewController.m
//  Scarecrow
//
//  Created by duanhongjin on 2017/3/19.
//  Copyright © 2017年 duanhongjin. All rights reserved.
//

#import "ADPopluarRepositoriesViewController.h"

@interface ADPopluarRepositoriesViewController ()

@end

@implementation ADPopluarRepositoriesViewController

+ (ADViewController *)viewController {
    ADPopluarRepositoriesViewController *vc = [[ADPopluarRepositoriesViewController alloc]initWithNibName:@"ADPopluarRepositoriesViewController" bundle:nil];
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
