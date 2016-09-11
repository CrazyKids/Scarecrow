//
//  ADViewController.m
//  Scarecrow
//
//  Created by duanhongjin on 7/7/16.
//  Copyright © 2016 duanhongjin. All rights reserved.
//

#import "ADViewController.h"
#import <ZRAlertController/ZRAlertController.h>
#import "SSKeychain+Scarecrow.h"
#import "ADLoginViewModel.h"

@interface ADViewController ()

@property (strong, nonatomic) ADViewModel *viewModel;

@end

@implementation ADViewController

+ (ADViewController *)viewController {    
    return nil;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    ADViewController *vc = [super allocWithZone:zone];
    
    @weakify(vc);
    [[vc rac_signalForSelector:@selector(viewDidLoad)]subscribeNext:^(id x) {
        @strongify(vc);
        [vc bindViewModel];
    }];
    
    return vc;
}

- (instancetype)initWithViewModel:(ADViewModel *)viewModel {
    self = [self init];
    if (self) {
        [self initializeWithViewMode:viewModel];
    }
    return self;
}

- (void)initializeWithViewMode:(ADViewModel *)viewModel {
    self.viewModel = viewModel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
}

- (void)bindViewModel {
    RAC(self, title) = RACObserve(self.viewModel, title);
    
    UIView *titleView = self.navigationItem.titleView;

    UIView *loadingTitleView = [[NSBundle mainBundle] loadNibNamed:@"ADLoadingTitleView" owner:nil options:nil].firstObject;
    loadingTitleView.frame = CGRectMake((LAYOUT_DEFAULT_WIDTH - 106) / 2, 0, 106, 44);
    
    RAC(self.navigationItem, titleView) = [RACObserve(self.viewModel, titleViewType).distinctUntilChanged map:^id(NSNumber *type) {
        switch (type.integerValue) {
            case ADTitleViewTypeLoading:
                return loadingTitleView;
            default:
                break;
        }
        return titleView;
    }];
    
    [self.viewModel.errors subscribeNext:^(NSError *error) {        
        NSLog(@"%@", error);
        
        if ([error.domain isEqualToString:OCTClientErrorDomain] && error.code == OCTClientErrorAuthenticationFailed) {
            NSString *message = @"Your authorization has expired, please login again";
            [[ZRAlertController defaultAlert]alertShowWithTitle:nil message:message okayButton:@"OK" completion:^{
                [SSKeychain deleteAccessToken];
                
                ADLoginViewModel *tabBarViewModel = [ADLoginViewModel new];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[ADPlatformManager sharedInstance]resetRootViewModel:tabBarViewModel];
                });
            }];
        }
    }];
}

#pragma mark - Autorotate
- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

#pragma mark - Auto hidden keyboard
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    
    [self.view endEditing:YES];
}

@end
