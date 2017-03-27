//
//  ADShowCasesViewController.m
//  Scarecrow
//
//  Created by duanhongjin on 2017/3/19.
//  Copyright © 2017年 duanhongjin. All rights reserved.
//

#import "ADShowCasesViewController.h"

@interface ADShowCasesViewController ()

@end

@implementation ADShowCasesViewController

+ (ADViewController *)viewController {
    ADShowCasesViewController *vc = [[ADShowCasesViewController alloc]initWithNibName:@"ADShowCasesViewController" bundle:nil];
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [super tableView:tableView cellForRowAtIndexPath:indexPath];
}

@end
