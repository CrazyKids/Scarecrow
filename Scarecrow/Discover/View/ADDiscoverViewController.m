//
//  ADDiscoverViewController.m
//  Scarecrow
//
//  Created by duanhongjin on 17/03/2017.
//  Copyright © 2017 duanhongjin. All rights reserved.
//

#import "ADDiscoverViewController.h"
#import "ADDiscoverItemViewModel.h"
#import "ADDiscoverViewModel.h"

@interface ADDiscoverViewController ()

@property (strong, nonatomic, readonly) ADDiscoverViewModel *viewModel;

@end

@implementation ADDiscoverViewController

@dynamic viewModel;

+ (ADViewController *)viewController {
    ADViewController *vc = [[UIStoryboard storyboardWithName:@"Discover" bundle:nil]instantiateViewControllerWithIdentifier:@"Discover"];
    
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCellStyleValue1" forIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    NSArray *sectionData = self.viewModel.dataSourceArray[indexPath.section];
    ADDiscoverItemViewModel *viewModel = sectionData[indexPath.row];
    
//    cell.imageView.image = viewModel.itemIcon;
    cell.textLabel.text = viewModel.itemName;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 15.0;
}

@end
