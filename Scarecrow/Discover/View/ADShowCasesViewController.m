//
//  ADShowCaseViewController.m
//  Scarecrow
//
//  Created by duanhongjin on 2017/3/19.
//  Copyright © 2017年 duanhongjin. All rights reserved.
//

#import "ADShowCasesViewController.h"
#import "ADShowCasesViewModel.h"
#import "ADShowCaseItemTableViewCell.h"
#import "ADShowCaseItemViewModel.h"

@interface ADShowCasesViewController ()

@property (strong, nonatomic) ADShowCasesViewModel *viewModel
;

@end

@implementation ADShowCasesViewController

@dynamic viewModel;

+ (ADViewController *)viewController {
    ADShowCasesViewController *vc = [[ADShowCasesViewController alloc]initWithNibName:@"ADShowCasesViewController" bundle:nil];
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ADShowCaseItemTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    ADShowCaseItemViewModel *viewModel = self.viewModel.dataSourceArray[indexPath.section][indexPath.row];
    
    return viewModel.height;
}

#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ADShowCaseItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    ADShowCaseItemViewModel *viewModel = self.viewModel.dataSourceArray[indexPath.section][indexPath.row];
    
    [cell bindModel:viewModel];
    return cell;
}

@end
