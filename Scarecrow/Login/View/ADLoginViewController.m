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
#import <ZRAlertController/ZRAlertController.h>

@interface ADLoginViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *oauthLoginButton;

@property (strong, nonatomic, readonly) ADLoginViewModel *viewModel;

@end

@implementation ADLoginViewController

@dynamic viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupAnimationUI];
    
#ifdef DEBUG
    self.usernameTextField.text = @"duanhjlt@163.com";
    self.passwordTextField.text = @"github_19850829";
#endif
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)bindViewModel {
    [super bindViewModel];
    
    RAC(self.viewModel, username) = self.usernameTextField.rac_textSignal;
    RAC(self.viewModel, password) = self.passwordTextField.rac_textSignal;
    
    NSString *username = SSKeychain.username;
    if (username) {
        self.usernameTextField.text = username;
        self.passwordTextField.text = SSKeychain.password;
    }
    
    RAC(self.loginButton, enabled) = self.viewModel.validLoginSingal;
    
    [[self.loginButton rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        [self.viewModel.loginCommand execute:nil];
    }];
    
    self.oauthLoginButton.rac_command = self.viewModel.oauthLoginCommand;
    
    @weakify(self);
    [[[RACSignal merge:@[self.viewModel.loginCommand.executing, self.viewModel.exchangeTokenCommand.executing]]doNext:^(id x) {
        @strongify(self)
        [self.view endEditing:YES];
    }]subscribeNext:^(NSNumber *executing) {
        @strongify(self);
        if (executing.boolValue) {
            [MBProgressHUD showHUDAddedTo:self.view animated:YES].label.text = @"Loading...";
        } else {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }
    }];
    
    [[RACSignal merge:@[self.viewModel.loginCommand.errors, self.viewModel.exchangeTokenCommand.errors]]subscribeNext:^(NSError *error) {
        @strongify(self);
        if ([error.domain isEqualToString:OCTClientErrorDomain] && error.code == OCTClientErrorTwoFactorAuthenticationOneTimePasswordRequired) {
            [[ZRAlertController defaultAlert]alertShow:self title:@"" message:@"Please enter the 2FA code you received via SMS or read from an authenticator app" cancelButton:@"Cancel" okayButton:@"OK" alertStyle:ZRAlertStylePlainTextInput placeHolder:@"2FA code" okayHandler:^(UITextField * _Nonnull textFiled) {
                [self.viewModel.loginCommand execute:textFiled.text];
            } cancelHandler:^(UITextField * _Nonnull textFiled) {
                
            }];
        } else {
            NSString *desc = error.localizedDescription;
            if ([error.domain isEqualToString:OCTClientErrorDomain] && error.code == OCTClientErrorAuthenticationFailed) {
                desc = @"Incorrect username or password";
            }
            
            [[ZRAlertController defaultAlert]alertShow:self title:@"" message:desc okayButton:@"OK" completion:^{
                
            }];
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
