//
//  ADLoginViewController.m
//  Scarecrow
//
//  Created by duanhongjin on 7/7/16.
//  Copyright © 2016 duanhongjin. All rights reserved.
//

#import "ADLoginViewController.h"
#import "ADLoginAnimation.h"
#import "ADLoginViewModel.h"
#import "SSKeychain+Scarecrow.h"

@interface ADLoginViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *oauthLoginButton;

@end

@implementation ADLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupAnimationUI];
}

- (void)bindViewModel {
    [super bindViewModel];
    
    ADLoginViewModel *loginViewModel = (ADLoginViewModel *)self.viewModel;
    
    RAC(loginViewModel, username) = self.usernameTextField.rac_textSignal;
    RAC(loginViewModel, password) = self.passwordTextField.rac_textSignal;
    
    NSString *username = SSKeychain.username;
    if (username) {
        self.usernameTextField.text = username;
        self.passwordTextField.text = SSKeychain.password;
    }
    
    RAC(self.loginButton, enabled) = loginViewModel.validLoginSingal;
    
    [[self.loginButton rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        [loginViewModel.loginCommand execute:nil];
    }];
    
    @weakify(self)
    [[[RACSignal merge:@[loginViewModel.loginCommand.executing, loginViewModel.exchangeTokenCommand.executing]]doNext:^(id x) {
        @strongify(self)
        [self.view endEditing:YES];
    }]subscribeNext:^(NSNumber *executing) {
        @strongify(self)
        if (executing.boolValue) {
            [MBProgressHUD showHUDAddedTo:self.view animated:YES].label.text = @"Loading...";
        } else {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }
    }];
}

- (void)setupAnimationUI {
    [ADLoginAnimation logoImageViewAnimation:self.logoImageView];
    [ADLoginAnimation loginItemAnimation:self.usernameTextField delay:0.1];
    [ADLoginAnimation loginItemAnimation:self.passwordTextField delay:0.2];
    [ADLoginAnimation loginItemAnimation:self.loginButton delay:0.3];
}

@end
