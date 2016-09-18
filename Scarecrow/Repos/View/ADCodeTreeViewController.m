//
//  ADCodeTreeViewController.m
//  Scarecrow
//
//  Created by duanhongjin on 9/18/16.
//  Copyright © 2016 duanhongjin. All rights reserved.
//

#import "ADCodeTreeViewController.h"
#import "ADCodeTreeViewModel.h"

@interface ADCodeTreeViewController ()

@property (strong, nonatomic, readonly) ADCodeTreeViewModel *viewModel;

@end

@implementation ADCodeTreeViewController

@dynamic viewModel;

+ (ADViewController *)viewController {
    return [[ADCodeTreeViewController alloc]initWithNibName:@"ADCodeTreeViewController" bundle:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    
    OCTTreeEntry *entry = self.viewModel.dataSourceArray[indexPath.section][indexPath.row];
    
    cell.textLabel.text = [entry.path componentsSeparatedByString:@"/"].lastObject;
    
    return cell;
}

@end
