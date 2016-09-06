//
//  ADTableViewController.h
//  Scarecrow
//
//  Created by duanhongjin on 16/7/24.
//  Copyright © 2016年 duanhongjin. All rights reserved.
//

#import "ADViewController.h"

@interface ADTableViewController : ADViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (assign, nonatomic) BOOL showLoading;

- (void)reloadData;
- (UIEdgeInsets)contentInsets;

@end
