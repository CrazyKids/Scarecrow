//
//  ZRQRCodeViewController.m
//  ZRQRCodeViewController
//
//  Created by Victor John on 7/1/16.
//  Copyright © 2016 XiaoRuiGeGe. All rights reserved.
//
//  https://github.com/VictorZhang2014/ZRQRCodeViewController
//  An open source library for iOS in Objective-C that is being compatible with iOS 7.0 and later.
//  Its main function that QR Code Scanning framework that are easier to call.
//

#import "ZRQRCodeViewController.h"
#import "ZRQRCodeController.h"
#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "ZRQRGenerateCode.h"

#define ScanMenuHeight 45
#define ABOVEiOS8 [[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0

typedef void(^ActionBlock)(int index, NSString *item);

typedef NS_ENUM(NSInteger)
{
    ZRQRCodeExtractTypeFromPhotoLibrary,
    ZRQRCodeExtractTypeByScanning
}ZRQRCodeExtractType;

@interface ZRQRCodeViewController ()<AVCaptureMetadataOutputObjectsDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate>
{
    AVCaptureSession * session;
    UIButton * torchBtn;
}

@property (nonatomic, strong) NSTimer *scanTimer;
@property (nonatomic, strong) UIImageView *scanImage0;
@property (nonatomic, strong) UIImageView *scanImage1;
@property (nonatomic, assign) CGRect captureRectArea;
@property (nonatomic, strong) CIDetector *detector;
@property (nonatomic, strong) NSArray *qrCodeActionSheets;
@property (nonatomic, strong) UIView *customView;
@property (nonatomic, copy) NSString *navigationBarTitle;

@property (nonatomic, strong) ZRAudio *playSound;

@property (nonatomic, strong) UIViewController *lastController;//The last controller

@property (nonatomic, strong) ZRCustomBundle *customBundle;

@property (nonatomic, copy) MyBlockFailure blockFailure;
@property (nonatomic, assign) ZRQRCodeExtractType codeExtractType;

@property (nonatomic, copy) ActionBlock actionBlockHandler;
@property (nonatomic, copy) MyBlockCompletion recognizeCompletion;
@property (nonatomic, copy) MyActionSheetCompletion actionSheetCompletion;
@end

@implementation ZRQRCodeViewController

- (NSString *)errorMessage
{
    if (!_errorMessage) {
        _errorMessage = @"Access Denied. To access iPhone's Photos/Camera ,please authorize in Settings. ";
    }
    return _errorMessage;
}

- (ZRCustomBundle *)customBundle
{
    if (!_customBundle) {
        _customBundle = [[ZRCustomBundle alloc] initWithBundleName:@"ZRQRCode"];
    }
    return _customBundle;
}

- (NSArray *)qrCodeActionSheets
{
    if (!_qrCodeActionSheets) {
        _qrCodeActionSheets = [[NSArray alloc] init];
    }
    return _qrCodeActionSheets;
}

- (CIDetector *)detector
{
    if (!_detector) {
        _detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{ CIDetectorAccuracy : CIDetectorAccuracyHigh }];
    }
    return _detector;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)setEnabledLight:(BOOL)enabledLight
{
    if (!enabledLight) {
        _enabledLight = true;
    } else {
        _enabledLight = false;
    }
}

- (instancetype)initWithScanType:(ZRQRCodeScanType)scanType
{
    if (self = [super init]) {
        self.scanType = scanType;
    }
    return self;
}

- (instancetype)initWithScanType:(ZRQRCodeScanType)scanType customView:(UIView *)customView navigationBarTitle:(NSString *)title
{
    if (self = [super init]) {
        self.scanType = scanType;
        self.customView = customView;
        self.navigationBarTitle = title;
    }
    return self;
}

/*
 * QR Code Scanning immediately
 **/
- (void)QRCodeScanningWithViewController:(UIViewController *)viewController completion:(MyBlockCompletion)completion failure:(MyBlockFailure)failure
{
    if (!viewController) {
        NSLog(@"Parameter viewController can not nil!");
        return;
    }
    
    if (completion) {
        self.recognizeCompletion = completion;
    }

    if (failure) {
        self.blockFailure = failure;
        self.codeExtractType = ZRQRCodeExtractTypeByScanning;
    }
    
    if (self.customView) {
        [self pushController:viewController];
    } else {
        [viewController presentViewController:self animated:NO completion:^{}];
    }
}

/*
 * Recogize a QR Code picture through the Photo Library
 **/
- (void)recognizationByPhotoLibraryViewController:(UIViewController *)viewController completion:(MyBlockCompletion)completion failure:(MyBlockFailure)failure
{
    if (!viewController) {
        NSLog(@"Parameter viewController can not nil!");
        return;
    }
    
    if (completion) {
        self.recognizeCompletion = completion;
    }
    
    if (failure) {
        self.blockFailure = failure;
        self.codeExtractType = ZRQRCodeExtractTypeFromPhotoLibrary;
    }
    
    [viewController addChildViewController:self];
    self.lastController = viewController;
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:^{}];
}

/*
 * Extract QR Code by Long press object , which maybe is UIImageView, UIButton, UIWebView, WKWebView, UIView, UIViewController , all of them , but that's okay for this method to extract.
 **/
- (void)extractQRCodeByLongPressViewController:(UIViewController *)viewController Object:(id)object completion:(MyBlockCompletion)completion failure:(MyBlockFailure)failure
{
    if (!viewController) {
        NSLog(@"Parameter viewController can not nil!");
        return;
    }
    
    if (!object) {
        NSLog(@"Parameter object can not nil!");
        return;
    }
    
    if (failure) {
        self.blockFailure = failure;
        self.codeExtractType = ZRQRCodeExtractTypeFromPhotoLibrary;
    }
    
    if (completion) {
        self.recognizeCompletion = completion;
    }
    
    [self bindLongPressGesture:viewController Object:object];
}

- (void)extractQRCodeByLongPressViewController:(UIViewController *)viewController Object:(id)object actionSheetCompletion:(MyActionSheetCompletion)actionSheetsCompletion completion:(MyBlockCompletion)completion failure:(MyBlockFailure)failure
{
    if (!viewController) {
        NSLog(@"Parameter viewController can not nil!");
        return;
    }
    
    if (!object) {
        NSLog(@"Parameter object can not nil!");
        return;
    }
    
    if (completion) {
        self.recognizeCompletion = completion;
    }
    
    if (failure) {
        self.blockFailure = failure;
        self.codeExtractType = ZRQRCodeExtractTypeFromPhotoLibrary;
    }
    
    if (actionSheetsCompletion) {
        self.actionSheetCompletion = actionSheetsCompletion;
    }
    
    [self bindLongPressGesture:viewController Object:object];
}

- (NSString *)canRecognize:(UIImage *)image
{
    NSString *result = [[NSString alloc] init];
    NSArray *features = [self.detector featuresInImage:[CIImage imageWithCGImage:image.CGImage]];
    if (features.count >= 1) {
        CIQRCodeFeature *feature = [features objectAtIndex:0];
        result = feature.messageString;
    }
    return result;
}

- (void)setActionSheets:(NSArray *)actionSheets
{
    _actionSheets = actionSheets;
    if (_actionSheets && _actionSheets.count > 0) {
        self.qrCodeActionSheets = _actionSheets;
    }
}

- (void)bindLongPressGesture:(UIViewController *)viewController Object:(id)object
{
    [viewController addChildViewController:self];
    self.lastController = viewController;
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(extractQRCodeByLongPress:)];
    
    if ([object isKindOfClass:[UIImageView class]]) {
        
        UIImageView *imgView = (UIImageView *)object;
        imgView.userInteractionEnabled = YES;
        [imgView addGestureRecognizer:longPressGesture];
    } else if ([object isKindOfClass:[UIButton class]]) {
        
        UIButton *button = (UIButton *)object;
        button.userInteractionEnabled = YES;
        [button addGestureRecognizer:longPressGesture];
    } else if ([object isKindOfClass:[UIWebView class]]) {
        
        UIWebView *webView = (UIWebView *)object;
        webView.userInteractionEnabled = YES;
        [webView addGestureRecognizer:longPressGesture];
    } else if ([object isKindOfClass:[UIView class]]) {
        
        UIView *lview = (UIView *)object;
        lview.userInteractionEnabled = YES;
        [lview addGestureRecognizer:longPressGesture];
    } else if ([object isKindOfClass:[UIViewController class]]) {
        
        UIViewController *viewV = (UIViewController *)object;
        viewV.view.userInteractionEnabled = YES;
        [viewV.view addGestureRecognizer:longPressGesture];
    } else {
        bool isWKWebView = false;
        if (ABOVEiOS8) {
            if ([object isKindOfClass:[WKWebView class]]) {
                isWKWebView = true;
                WKWebView *webView = (WKWebView *)object;
                webView.userInteractionEnabled = YES;
                [webView addGestureRecognizer:longPressGesture];
            }
        }
        
        if (!isWKWebView && self.recognizeCompletion) {
            self.recognizeCompletion(@"Can not support other type of object! ");
        }
    }
}

- (void)extractQRCodeByLongPress:(UIGestureRecognizer *)gesture
{
    NSMutableArray *tmpArr = [[NSMutableArray alloc] init];
    if (self.qrCodeActionSheets.count > 0) {
        for (NSString *str in self.qrCodeActionSheets) {
            [tmpArr addObject:str];
        }
    }
    
    NSString *tExtractTxt = [[NSString alloc] init];
    if (self.extractQRCodeText && self.extractQRCodeText.length > 0) {
        [tmpArr addObject:self.extractQRCodeText];
    } else {
        tExtractTxt = @"Extract QR Code";
        [tmpArr addObject:tExtractTxt];
    }
    
    NSString *tSaveImg = [[NSString alloc] init];
    if (self.saveImaegText && self.saveImaegText.length > 0) {
        [tmpArr addObject:self.saveImaegText];
    } else {
        tSaveImg = @"Save Image";
        [tmpArr addObject:tSaveImg];
    }
    
    NSString *tmpCancel = @"Cancel";
    if (self.cancelButton && self.cancelButton.length > 0) {
        tmpCancel = self.cancelButton;
    }
    
    __weak typeof(self) SELF = self;
    [self actionViewWithTitle:@"" cancel:tmpCancel others:tmpArr handler:^(int index, NSString * _Nonnull item) {
        
        if ((tExtractTxt.length > 0 || SELF.extractQRCodeText.length > 0) &&
            ([tExtractTxt isEqualToString:item] || [SELF.extractQRCodeText isEqualToString:item])) {
            UIImage *image = [SELF screenShotImageByView:SELF.lastController.view];
            [SELF detectQRCodeFromImage:image];
        } else if ((tSaveImg.length > 0 || SELF.saveImaegText.length > 0) &&
                   ([tSaveImg isEqualToString:item] || [SELF.saveImaegText isEqualToString:item])) {
            UIImage *image = [SELF screenShotImageByView:SELF.lastController.view];
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
        }

        if (SELF.actionSheetCompletion) {
            SELF.actionSheetCompletion(index, item);
        }
    }];
}

- (BOOL)canAccessCamera
{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
        return NO;
    }
    return YES;
}

- (BOOL)canAccessPhotos
{
    if (ABOVEiOS8) {
        PHAuthorizationStatus auth = [PHPhotoLibrary authorizationStatus];
        if(auth == PHAuthorizationStatusDenied || auth == PHAuthorizationStatusRestricted){
            return NO;
        }
    } else {
        ALAuthorizationStatus authStatus = [ALAssetsLibrary authorizationStatus];
        if (authStatus == ALAuthorizationStatusDenied || authStatus == ALAuthorizationStatusRestricted) {
            return NO;
        }
    }
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Determine the authorization
    if (self.codeExtractType == ZRQRCodeExtractTypeFromPhotoLibrary) {
        if (![self canAccessPhotos]) {
            if (self.blockFailure) {
                self.blockFailure(self.errorMessage);
            }
            [self dismissController];
            return;
        }
    } else if (self.codeExtractType == ZRQRCodeExtractTypeByScanning) {
        if (![self canAccessCamera]) {
            if (self.blockFailure) {
                self.blockFailure(self.errorMessage);
            }
            [self dismissController];
            return;
        }
    }
    
    _playSound = [[ZRAudio alloc] init];
    
    //1.Config Camera
    [self configDevice]; 
    
    if (self.customView) {
        [self.view addSubview:self.customView];
        if (!self.enabledLight) 
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[self createLight:CGRectMake(0, 0, 28, 28)]];
        if (self.VCTintColor)
            self.navigationController.navigationBar.tintColor = self.VCTintColor;
        self.navigationItem.title = self.navigationBarTitle;
        NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [UIColor whiteColor],
                                    NSForegroundColorAttributeName, nil];
        [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    } else {
        //2.Config UI part of head and bottom
        [self configMenus];
        
        //3.Config scanning files
        [self configScanPic];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.9 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self scanningTimer];
        if (![session isRunning]) {
            [session startRunning];
        }
    });
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self stopScanning];
    if ([session isRunning]) {
        [session stopRunning];
    }
}

#pragma mark - UIImagePickerControllerDelegate event
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{}];
    [[self.lastController.childViewControllers lastObject] removeFromParentViewController];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    if (!image){
        image = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    
    [self detectQRCodeFromImage:image];
}

#pragma mark - 1.Config Camera
- (void)configDevice
{
    AVCaptureDevice * device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if(device){
        AVCaptureDeviceInput * input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
        AVCaptureMetadataOutput * output = [[AVCaptureMetadataOutput alloc]init];
        //Set delegate on running the main thread
        [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
        
        session = [[AVCaptureSession alloc]init];
        //Adopted rate in High Capture Quality
        [session setSessionPreset:AVCaptureSessionPresetHigh];
        
        [session addInput:input];
        [session addOutput:output];
        
        //Setup QR code encoding format
        output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode,
                                       AVMetadataObjectTypeEAN13Code,
                                       AVMetadataObjectTypeEAN8Code,
                                       AVMetadataObjectTypeCode128Code];
        
        AVCaptureVideoPreviewLayer * layer = [AVCaptureVideoPreviewLayer layerWithSession:session];
        layer.videoGravity = AVLayerVideoGravityResize;
        layer.frame = self.view.layer.bounds;
        [self.view.layer insertSublayer:layer atIndex:0];
        
        //Capture Area
        CGRect rect = self.view.frame;
        int width = rect.size.width * 0.65;
        rect.origin.x = (rect.size.width - width) / 2;
        rect.origin.y = (rect.size.height - width) / 2;
        rect.size.height = width;
        rect.size.width = width;
        self.captureRectArea = rect;
        
        //Specific scanning size area
        //        CGFloat screenHeight = self.view.frame.size.height;
        //        CGFloat screenWidth = self.view.frame.size.width;
        //        CGRect rectInterest = CGRectMake(rect.origin.x / screenWidth, rect.origin.y / screenHeight, rect.size.width / screenWidth, rect.size.height / screenHeight);
        //        [output setRectOfInterest:rectInterest];
        
        //Starting Capture
        [session startRunning];
    }
}

#pragma mark - 2.Config UI part of head and bottom
- (void)configMenus
{
    //Part of Head
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, ScanMenuHeight + 10)];
    [topView setBackgroundColor:[UIColor blackColor]];
    topView.alpha = 0.5;
    [self.view addSubview:topView];
    
    CGFloat titleW = 200;
    CGFloat titleH = 30;
    CGFloat titleY = 20;
    CGFloat titleX = (self.view.frame.size.width - titleW) / 2;
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(titleX, titleY, titleW, titleH)];
    [title setTextAlignment:NSTextAlignmentCenter];
    if (self.qrCodeNavigationTitle && self.qrCodeNavigationTitle.length > 0) {
        title.text = self.qrCodeNavigationTitle;
    } else {
        title.text = @"QR Code Scanning";
    }
    
    [title setTextColor:[UIColor whiteColor]];
    [self.view addSubview:title];
    
    
    //Close Button
    CGFloat btnW = 25;
    CGFloat btnH = 20;
    CGFloat btnX = 10;
    CGFloat btnY = 23;
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(btnX, btnY, btnW, btnH)];
    [backBtn setBackgroundImage:[self.customBundle getImageWithName:@"ZR_Backward"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(closeQRCodeScan) forControlEvents:UIControlEventTouchUpInside];
    [backBtn.imageView setTintColor:[UIColor whiteColor]];
    [backBtn setTintColor:[UIColor whiteColor]];
    [self.view addSubview:backBtn];
    
    //Part of Bottom
    CGFloat bottomY = self.view.frame.size.height - ScanMenuHeight;
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, bottomY, self.view.frame.size.width, ScanMenuHeight)];
    [bottomView setBackgroundColor:[UIColor blackColor]];
    bottomView.alpha = 0.5;
    [self.view addSubview:bottomView];
    
    //Turn On Or Off on switch
    CGFloat openW = 28;
    CGFloat openH = 28;
    CGFloat openX = 11;
    CGFloat openY = 8;
    [bottomView addSubview:[self createLight:CGRectMake(openX, openY, openW, openH)]];
    
    UILabel *tipsLabel = [[UILabel alloc] init];
//    [tipsLabel setText:@"Alignment"];
    [tipsLabel setTextColor:[UIColor whiteColor]];
    tipsLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:tipsLabel];
    tipsLabel.translatesAutoresizingMaskIntoConstraints = NO;
 
    NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:tipsLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:self.view.frame.size.width - 50];
    [tipsLabel addConstraint:width];
    
    NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:tipsLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:100];
    [tipsLabel addConstraint:height];
    
    NSLayoutConstraint *centerX = [NSLayoutConstraint constraintWithItem:tipsLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0];
    [self.view addConstraint:centerX];
    
    NSLayoutConstraint *centerY = [NSLayoutConstraint constraintWithItem:tipsLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0];
    [self.view addConstraint:centerY];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
}

- (UIButton *)createLight:(CGRect)rect
{
    UIButton *openlight = [[UIButton alloc] initWithFrame:rect];
    [openlight setBackgroundImage:[self.customBundle getImageWithName:@"ZR_qrcode_torch_btn"] forState:UIControlStateNormal];
    [openlight setBackgroundImage:[self.customBundle getImageWithName:@"ZR_qrcode_torch_btn_selected"] forState:UIControlStateSelected];
    [openlight addTarget:self action:@selector(torchOnOrOff) forControlEvents:UIControlEventTouchUpInside];
    torchBtn = openlight;
    return openlight;
}

#pragma mark - 3.Config scanning files
- (void)configScanPic
{
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[self stretchImage:@"ZR_ScanFrame"]];
    imgView.frame = self.captureRectArea; 
    [self.view addSubview:imgView];
    self.scanImage0 = imgView;
    
    CGRect sImgRect = CGRectMake(10, 5, self.captureRectArea.size.width - 20, 10);
    UIImageView *scanImg = [[UIImageView alloc] initWithImage:[self.customBundle getImageWithName:@"ZR_ScanLine"]];
    scanImg.frame = sImgRect;
    [imgView addSubview:scanImg];
    self.scanImage1 = scanImg;
}

#pragma mark - Scanning Timer
- (void)scanningTimer
{
    if(!self.scanTimer && !self.customView){
        self.scanTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(scanning) userInfo:nil repeats:YES];
    }
}
- (void)scanning
{
    [UIView animateWithDuration:0.5 animations:^{
        CGRect rect = self.scanImage0.frame;
        CGRect rect1 = self.scanImage1.frame;
        rect1.origin.y = rect.size.height - rect1.size.height * 2;
        self.scanImage1.frame = rect1;
    } completion:^(BOOL finished) {
        if(finished){
            [UIView animateWithDuration:0.5 animations:^{
                CGRect rect = self.scanImage1.frame;
                rect.origin.y = 5;
                self.scanImage1.frame = rect;
            }];
        }
    }];
}

#pragma mark Stop Scanning
- (void)stopScanning
{
    if (!self.customView) {
        [self.scanTimer invalidate];
    }
}

- (void)pauseScanning
{
    if (!self.customView) {
        [self.scanTimer setFireDate:[NSDate distantFuture]];
    }
}

- (void)continueScanning
{
    if (!self.customView) {
        [self.scanTimer setFireDate:[NSDate date]];
    }
}

#pragma mark Close Scanning
- (void)closeQRCodeScan
{
    [session stopRunning];
    [self dismissController];
}

#pragma mark The switch , turn On or Off
- (void)torchOnOrOff
{
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    [device lockForConfiguration:nil];
    if (device.torchMode == AVCaptureTorchModeOff) {
        [device setTorchMode: AVCaptureTorchModeOn];
        [torchBtn setSelected:YES];
    }else{
        [device setTorchMode: AVCaptureTorchModeOff];
        [torchBtn setSelected:NO];
    }
    [device unlockForConfiguration];
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate event
-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    if (metadataObjects.count > 0) {
        [self playSoundWhenScanSuccess];
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        NSString *svalue = metadataObject.stringValue;
        [session stopRunning];
        if (self.scanType == ZRQRCodeScanTypeReturn) {
            [self stopScanning];
            [self dismissController];
        } else if (self.scanType == ZRQRCodeScanTypeContinuation) {
            [self pauseScanning];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.9 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [session startRunning];
                [self continueScanning];
            });
        }
        if (self.recognizeCompletion) {
            self.recognizeCompletion(svalue);
        }
    }
}

- (UIImage *)stretchImage:(NSString *)imgPath
{
    UIImage *img = [self.customBundle getImageWithName:imgPath];
    return [img stretchableImageWithLeftCapWidth:img.size.width * 0.5f topCapHeight:img.size.height * 0.5f];
}

- (UIImage *)screenShotImageByView:(UIView *)view
{
    UIGraphicsBeginImageContext([UIScreen mainScreen].bounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [view.layer renderInContext:context];
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

- (void)detectQRCodeFromImage:(UIImage *)image
{
    NSString *strValue = [[NSString alloc] init];
    NSArray *features = [self.detector featuresInImage:[CIImage imageWithCGImage:image.CGImage]];
    if (features.count >= 1) {
        [self playSoundWhenScanSuccess];
        CIQRCodeFeature *feature = [features objectAtIndex:0];
        strValue = feature.messageString;
    } else {
        if (!self.textWhenNotRecognized) {
            self.textWhenNotRecognized = @"No any QR Code texture on the picture were found!";
        }
        strValue = [[NSString alloc] initWithString:self.textWhenNotRecognized];
    }
    if (self.recognizeCompletion) {
        self.recognizeCompletion(strValue);
    }
}

- (void)dealloc{
    
    if (self.scanTimer) {
        [self.scanTimer invalidate];
        self.scanTimer = nil;
    }

    if (self.recognizeCompletion) {
        self.recognizeCompletion = nil;
    }
    
    if (self.actionSheetCompletion) {
        self.actionSheetCompletion = nil;
    }
    
    if (self.customView) {
        self.customView = nil;
    }
    
    [self disposeSound];
}

/*
 * Create Or Dispose Sounds after scanning
 **/
- (void)playSoundWhenScanSuccess
{
    [self.playSound playSoundWhenScanSuccess];
}

- (void)disposeSound
{
    [self.playSound disposeSound];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    NSLog(@"ZRQRCodeController have received memory warning, so program kill this controller immediately.");
    [self dismissController];
}

- (void)pushController:(UIViewController *)viewController
{
    if (viewController.navigationController) {
        [viewController.navigationController pushViewController:self animated:false];
    } else {
        [viewController presentViewController:self animated:false completion:^{}];
    }
}

- (void)dismissController
{
    if ([self.navigationController.childViewControllers lastObject] == self) {
        [self.navigationController popViewControllerAnimated:false];
    } else {
        [self dismissViewControllerAnimated:false completion:^{}];
    }
}

#pragma mark  Orientations
- (BOOL)shouldAutorotate
{
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}


- (UIImageView *)generateQuickResponseCodeWithFrame:(CGRect)imageRect dataString:(NSString *)dataString
{
    return [[[ZRQRGenerateCode alloc] init] generateQuickResponseCodeWithFrame:imageRect dataString:dataString];
}


- (UIImageView *)generateQuickResponseCodeWithFrame:(CGRect)imageRect dataString:(NSString *)dataString centerImage:(UIImage *)image
{
   return [[[ZRQRGenerateCode alloc] init] generateQuickResponseCodeWithFrame:imageRect dataString:dataString centerImage:image];
}

- (UIImageView *)generateQuickResponseCodeWithFrame:(CGRect)imageRect dataString:(NSString *)dataString centerImage:(UIImage *)image needShadow:(BOOL)shadow
{
   return [[[ZRQRGenerateCode alloc] init] generateQuickResponseCodeWithFrame:imageRect dataString:dataString centerImage:image needShadow:YES];
}


- (void)actionViewWithTitle:(NSString * _Nullable)title cancel:(NSString *)cancel others:(NSArray *)others handler:(ActionBlock)handler
{
    if (ABOVEiOS8) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        for (int i = 0; i < others.count; i++) {
            UIAlertAction *action = [UIAlertAction actionWithTitle:others[i] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                if (handler) {
                    handler(i + 1, others[i]);
                }
            }];
            [alertController addAction:action];
        }
        if (cancel.length) {
            UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:cancel style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                if (handler) {
                    handler(0, cancel);
                }
            }];
            [alertController addAction:actionCancel];
        }
        if (self.lastController.navigationController) {
           [self.lastController.navigationController presentViewController:alertController animated:YES completion:nil];
        } else {
            [self.lastController presentViewController:alertController animated:YES completion:nil];
        }
        
    } else {
        self.actionBlockHandler = handler;
        UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:title delegate:self cancelButtonTitle:cancel destructiveButtonTitle:nil otherButtonTitles:nil, nil];
        for (NSString *item in others) {
            [action addButtonWithTitle:item];
        }
        [action showInView:self.lastController.view];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (self.actionBlockHandler) {
        self.actionBlockHandler((int)buttonIndex, [actionSheet buttonTitleAtIndex:buttonIndex]);
    }
}

@end


