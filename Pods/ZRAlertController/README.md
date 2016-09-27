# ZRAlertController
A delightful alert view framework that being compatible with iOS 7.0 and later.
It has the version both Objective-C and Swift.

How to install and get Started with CocoaPods
-----------------------------------

`platform :ios, '7.0'  

pod 'ZRAlertController', '~> 2.3`


## Usage of first style

`[[ZRAlertController defaultAlert] alertShowWithTitle:@"Note" message:@"This is an empty message!" okayButton:@"Ok"];`

### Effect Photo
![ZRAlertController Effect Photo 1](https://github.com/VictorZhang2014/ZRAlertController/blob/master/screenshots/one.png "ZRAlertController")

## Usage of second style

```
[[ZRAlertController defaultAlert] alertShowWithTitle:@"Note" message:@"This is an empty message!" cancelButton:@"Cancel" okayButton:@"Ok" okayHandler:^{
    NSLog(@"You clicked the okay button.");
} cancelHandler:^{
    NSLog(@"You clicked the cancel button.");
}];
```

### Effect Photo
![ZRAlertController Effect Photo 2](https://github.com/VictorZhang2014/ZRAlertController/blob/master/screenshots/two.png "ZRAlertController")

## Usage of third style

```
[[ZRAlertController defaultAlert] alertShowWithTitle:@"Note" message:@"This is an explanation message!" cancelButton:@"Cancel" okayButton:@"Okay" alertStyle:ZRAlertStyleSecureTextInput placeHolder:@"Type any character" okayHandler:^(UITextField *textFiled) {
    NSLog(@"Your input of textFiled is %@.", textFiled.text);
} cancelHandler:^(UITextField *textFiled) {
    NSLog(@"Your input of textFiled is %@.", textFiled.text);
}];
```

### Effect Photo
![ZRAlertController Effect Photo 3](https://github.com/VictorZhang2014/ZRAlertController/blob/master/screenshots/three.png "ZRAlertController")

## Usage of fourth style

```
[[ZRAlertController defaultAlert] alertShowWithTitle:@"Note" 
                                  message:@"This is an explanation message!" 
                                  cancelButton:@"Cancel" okayButton:@"Ok" 
                                  alertStyle:ZRAlertStyleLoginAndPasswordInput 
                                  placeHolder1:@"Type an account" 
                                  placeHolder2:@"Type a passcode" 
                                  sureHandler:^(UITextField *textFiled1, UITextField *textFiled2) {
    NSLog(@"Your input of Sure textFiled1.text = %@, textFiled2.text = %@. ", textFiled1.text, textFiled2.text);
} abolishHandler:^(UITextField *textFiled1, UITextField *textFiled2) {
    NSLog(@"Your input of Abolish textFiled1.text = %@, textFiled2.text = %@. ", textFiled1.text, textFiled2.text);
}];
```

### Effect Photo
![ZRAlertController Effect Photo 4](https://github.com/VictorZhang2014/ZRAlertController/blob/master/screenshots/four.png "ZRAlertController")

## Usage of first style action sheet

```
[[ZRAlertController defaultAlert] actionViewWithTitle:nil cancel:@"cancel" others:@[@"aaa",@"bbb",@"ccc"] handler:^(int index, NSString * _Nonnull item) {
    NSLog(@"index = %d, item = %@. ", index, item);
}];
```

### Effect Photo
![ZRAlertController Effect Photo 1](https://github.com/VictorZhang2014/ZRAlertController/blob/master/screenshots/five.png "ZRAlertController")




