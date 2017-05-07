//
//  ADBrowseViewController.m
//  Scarecrow
//
//  Created by duanhongjin on 2017/3/19.
//  Copyright © 2017年 duanhongjin. All rights reserved.
//

#import "ADBrowseViewController.h"

@interface ADBrowseViewController ()

@end

@implementation ADBrowseViewController

+ (ADViewController *)viewController {
    ADBrowseViewController *vc = [[ADBrowseViewController alloc]initWithNibName:@"ADBrowseViewController" bundle:nil];
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
