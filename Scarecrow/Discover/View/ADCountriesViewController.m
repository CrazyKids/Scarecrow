//
//  ADCountriesViewController.m
//  Scarecrow
//
//  Created by duanhongjin on 2017/3/26.
//  Copyright © 2017年 duanhongjin. All rights reserved.
//

#import "ADCountriesViewController.h"
#import "ADCountriesViewModel.h"

@interface ADCountriesViewController ()

@property (strong, nonatomic, readonly) ADCountriesViewModel *viewModel;

@end

@implementation ADCountriesViewController

@dynamic viewModel;

+ (ADViewController *)viewController {
    return [[ADCountriesViewController alloc]initWithNibName:@"ADCountriesViewController" bundle:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    @weakify(self)
    [[[RACObserve(self.viewModel, currentCountry) distinctUntilChanged]deliverOnMainThread]subscribeNext:^(id x) {
        @strongify(self)
        [self reloadData];
    }];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    if (self.isBeingDismissed || self.isMovingFromParentViewController) {
        if (self.viewModel.callback) {
            self.viewModel.callback(self.viewModel.currentCountry);
        }
    }
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSDictionary *language = self.viewModel.dataSourceArray[indexPath.section][indexPath.row];
    cell.textLabel.text = language[@"name"];
    
    if ([language[@"slug"] isEqualToString:self.viewModel.currentCountry[@"slug"]]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

@end
