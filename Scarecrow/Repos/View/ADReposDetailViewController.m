//
//  ADReposDetailViewController.m
//  Scarecrow
//
//  Created by duanhongjin on 16/9/11.
//  Copyright © 2016年 duanhongjin. All rights reserved.
//

#import "ADReposDetailViewController.h"
#import "ADReposDetailViewModel.h"
#import "ADReposDescTableViewCell.h"
#import "ADReposStatisticsTableViewCell.h"
#import "ADReposViewCodeTableViewCell.h"
#import "ADReposReadmeTableViewCell.h"
#import "UIImage+Scarecrow.h"
#import "OCTRef+Scarecrow.h"

@interface ADReposDetailViewController () <UIWebViewDelegate>

@property (strong, nonatomic, readonly) ADReposDetailViewModel *viewModel;
@property (strong, nonatomic) ADReposReadmeTableViewCell *readmeCell;
@property (strong, nonatomic) RACSignal *webviewExecuting;

@end

@implementation ADReposDetailViewController

@dynamic viewModel;

+ (ADViewController *)viewController {
    return [[ADReposDetailViewController alloc]initWithNibName:@"ADReposDetailViewController" bundle:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ADReposStatisticsTableViewCell" bundle:nil] forCellReuseIdentifier:@"satisticsCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"ADReposViewCodeTableViewCell" bundle:nil] forCellReuseIdentifier:@"viewCodeCell"];
    [self.tableView registerClass:[ADReposDescTableViewCell class] forCellReuseIdentifier:@"descCell"];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.allowsSelection = NO;
    self.tableView.estimatedRowHeight = 44;
    
    @weakify(self)
    [self.viewModel.fetchRemoteDataCommamd.executing subscribeNext:^(NSNumber *executing) {
        @strongify(self)
        if (executing.boolValue) {
            [MBProgressHUD showHUDAddedTo:self.view animated:YES].label.text = @"Loading...";
        } else {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }
    }];

    self.readmeCell = [[NSBundle mainBundle]loadNibNamed:@"ADReposReadmeTableViewCell" owner:nil options:nil].firstObject;
}

- (void)dealloc {
    self.readmeCell.webview.delegate = nil;
}

- (void)bindViewModel {
    [super bindViewModel];
    
    @weakify(self);
    [self.viewModel.changeBranchCommand.executing subscribeNext:^(NSNumber *executing) {
        @strongify(self);
        if (executing.boolValue) {
            [MBProgressHUD showHUDAddedTo:self.view animated:YES].label.text = @"Loading...";
        } else {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }
    }];
    
    [RACObserve(self.viewModel, repos) subscribeNext:^(id x) {
        @strongify(self);
        [self.tableView reloadData];
    }];
    
    [self.readmeCell bindViewModel:self.viewModel];
    
    RACSignal *startLoadSignal = [self rac_signalForSelector:@selector(webViewDidStartLoad:)];
    RACSignal *fininedLoadSignal = [self rac_signalForSelector:@selector(webViewDidFinishLoad:)];
    RACSignal *failedLoadSignal = [self rac_signalForSelector:@selector(webView:didFailLoadWithError:)];
    self.readmeCell.webview.delegate = self;
    
    RAC(self.readmeCell.webview, hidden) = [[[fininedLoadSignal mapReplace:@(NO)]distinctUntilChanged]startWith:@(YES)];
    
    [fininedLoadSignal subscribeNext:^(RACTuple *tuple) {
        @strongify(self);
        
        UIWebView *webview = tuple.first;
        
        CGRect frame = webview.frame;
        frame.size.height = 1;
        
        webview.frame = frame;
        CGSize fittingSize = [webview sizeThatFits:CGSizeZero];
        frame.size = fittingSize;
        webview.frame = frame;
        
        [self.tableView reloadData];
    }];
    
    self.webviewExecuting = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [[startLoadSignal mapReplace:@(YES)]subscribe:subscriber];
        [[[RACSignal merge:@[fininedLoadSignal, failedLoadSignal]]mapReplace:@(NO)]subscribe:subscriber];
        
        return nil;
    }];
    
    RAC(self.readmeCell.activityIndicator, hidden) = [self.webviewExecuting map:^id(NSNumber *executing) {
        return @(!executing.boolValue);
    }];
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    ADReposDetailData data = [self.viewModel.dataSourceArray[section][row] integerValue];
    switch (data) {
        case ADReposDetailDataDesc: {
            ADReposDescTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"descCell" forIndexPath:indexPath];
            [cell bindViewModel:self.viewModel];
            
            return cell;
        }
        case ADReposDetailDataStatistics: {
            ADReposStatisticsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"satisticsCell" forIndexPath:indexPath];
            [cell bindViewModel:self.viewModel];
                        
            return cell;
        }
        case ADReposDetailDataViewCode: {
            ADReposViewCodeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"viewCodeCell" forIndexPath:indexPath];
            [cell bindViewModel:self.viewModel];
            
            return cell;
        }
        case ADReposDetailDataReadme: {
            return self.readmeCell;
        }
        default:
            break;
    }
    
    return [super tableView:tableView cellForRowAtIndexPath:indexPath];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    ADReposDetailData data = [self.viewModel.dataSourceArray[section][row] integerValue];
    switch (data) {
        case ADReposDetailDataDesc:
            return UITableViewAutomaticDimension;
        case ADReposDetailDataStatistics:
            return 58;
        case ADReposDetailDataViewCode:
            return 114;
        case ADReposDetailDataReadme:
            return self.readmeCell.height;
        default:
            break;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 7.5f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 7.5f;
}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    return self.navigationController.topViewController == self;
}

@end
