//
//  ADLoginViewController.m
//  Scarecrow
//
//  Created by duanhongjin on 7/7/16.
//  Copyright © 2016 duanhongjin. All rights reserved.
//

#import "ADLoginViewController.h"
#import "ADLoginViewModel.h"
#import "SSKeychain+Scarecrow.h"
#import <ZRAlertController/ZRAlertController.h>
#import "UIColor+Scarecrow.h"

@interface ADLoginViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@property (strong, nonatomic, readonly) ADLoginViewModel *viewModel;

@end

@implementation ADLoginViewController

@dynamic viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.loginButton.layer.borderColor = DEFAULT_RGB.CGColor;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)bindViewModel {
    [super bindViewModel];
    
    self.loginButton.rac_command = self.viewModel.loginCommand;
    
    @weakify(self);
    [self.viewModel.exchangeTokenCommand.executing subscribeNext:^(NSNumber *executing) {
        @strongify(self);
        if (executing.boolValue) {
            [MBProgressHUD showHUDAddedTo:self.view animated:YES].label.text = @"Loading...";
        } else {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }
    }];
    
    [self.viewModel.loginCommand.errors subscribeNext:^(NSError *error) {
        NSString *desc = error.localizedDescription;
        if ([error.domain isEqualToString:OCTClientErrorDomain] && error.code == OCTClientErrorAuthenticationFailed) {
            desc = @"Incorrect username or password";
        }
        
        [[ZRAlertController defaultAlert]alertShow:self title:@"" message:desc okayButton:@"OK" completion:^{
            
        }];
    }];
}

@end
