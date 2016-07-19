//
//  MXReviewViewController.m
//  RACDemo
//
//  Created by YISHANG on 16/7/19.
//  Copyright © 2016年 MAXIAO. All rights reserved.
//

#import "MXReviewViewController.h"
#import <ReactiveCocoa.h>
@interface MXReviewViewController ()
@property (nonatomic, strong) UITextField  *usernameTextField;
@property (nonatomic, strong) UITextField  *passwordTextField;
@property (nonatomic, strong) UIButton  *loginButton;

@end

@implementation MXReviewViewController

#pragma mark - lazyInitlization
-(UITextField *)usernameTextField {
    if (!_usernameTextField) {
        _usernameTextField = [[UITextField alloc] initWithFrame:CGRectMake(self.view.center.x - 50, 100, 100, 30)];
        _usernameTextField.backgroundColor = [UIColor yellowColor];
        _usernameTextField.textColor = [UIColor blackColor];
    }
    return _usernameTextField;
}

- (UITextField *)passwordTextField {
    if (!_passwordTextField) {
        _passwordTextField = [[UITextField alloc] initWithFrame:CGRectMake(self.view.center.x - 50, 150, 100, 30)];
        _passwordTextField.backgroundColor = [UIColor yellowColor];
        _passwordTextField.textColor = [UIColor blackColor];
    }
    return _passwordTextField;
}

- (UIButton *)loginButton {
    if (!_loginButton) {
        _loginButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.center.x - 50, 200, 100, 30)];
        [_loginButton setTitle:@"login in" forState:(UIControlStateNormal)];
        _loginButton.backgroundColor = [UIColor blueColor];
        [_loginButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        _loginButton.enabled = NO;
    }
    return _loginButton;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
}

- (void)configUI {
    [self.view addSubview:self.usernameTextField];
    [self.view addSubview:self.passwordTextField];
    [self.view addSubview:self.loginButton];
    
    [[[self.usernameTextField rac_textSignal] filter:^BOOL(NSNumber *length) {
        return [length integerValue] > 3;
    }] subscribeNext:^(id x) {
        NSLog(@"username ---- %@", x);
    }];
    
    [[[self.passwordTextField rac_textSignal] filter:^BOOL(NSNumber *length) {
        return [length integerValue] > 3;
    }] subscribeNext:^(id x) {
        NSLog(@"password ---- %@", x);
    }];
}

@end
