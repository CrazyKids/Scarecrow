//
//  ADLanguageViewController.m
//  Scarecrow
//
//  Created by duanhongjin on 24/03/2017.
//  Copyright © 2017 duanhongjin. All rights reserved.
//

#import "ADLanguageViewController.h"
#import "ADLanguageViewModel.h"

@interface ADLanguageViewController ()

@property (strong, nonatomic, readonly) ADLanguageViewModel *viewModel;

@end

@implementation ADLanguageViewController

@dynamic viewModel;

+ (ADViewController *)viewController {
    return [[ADLanguageViewController alloc]initWithNibName:@"ADLanguageViewController" bundle:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    @weakify(self)
    [[[RACObserve(self.viewModel, currentLanguageDic) distinctUntilChanged]deliverOnMainThread]subscribeNext:^(id x) {
        @strongify(self)
        [self reloadData];
    }];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    if (self.beingDismissed || self.movingFromParentViewController) {
        if (self.viewModel.callback) {
            self.viewModel.callback(self.viewModel.currentLanguageDic);
        }
    }
}

#pragma mark - UITabelViewDatasource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSDictionary *language = self.viewModel.dataSourceArray[indexPath.section][indexPath.row];
    cell.textLabel.text = language[@"name"];
    
    if ([language[@"slug"] isEqualToString:self.viewModel.currentLanguageDic[@"slug"]]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

@end
