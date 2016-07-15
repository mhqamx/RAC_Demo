//
//  MXSecViewController.m
//  RACDemo
//
//  Created by YISHANG on 16/7/15.
//  Copyright © 2016年 MAXIAO. All rights reserved.
//

#import "MXSecViewController.h"
#import <ReactiveCocoa.h>
@interface MXSecViewController ()
@property (nonatomic, strong) UITextField  *textField;
@property (nonatomic, strong) UIButton  *button;


@end

@implementation MXSecViewController

- (UITextField *)textField {
    if (!_textField) {
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(100, 100, 100, 30)];
        _textField.placeholder = @"input here";
        _textField.backgroundColor = [UIColor redColor];
        _textField.textColor = [UIColor whiteColor];
    }
    return _textField;
}

- (UIButton *)button {
    if (!_button) {
        _button = [[UIButton alloc] initWithFrame:CGRectMake(200, 100, 100, 30)];
        [_button setTitle:@"pop" forState:(UIControlStateNormal)];
        _button.backgroundColor = [UIColor greenColor];
        [_button setTitleColor:[UIColor yellowColor] forState:(UIControlStateNormal)];
    }
    return _button;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"MXSecViewController";
    [self configUI];
}

- (void)configUI {
    [self.view addSubview:self.textField];
    [self.view addSubview:self.button];
    
    
    [[self.button rac_signalForControlEvents:(UIControlEventTouchUpInside)] subscribeNext:^(id x) {
        [self.kdelegate sengMessage:self.textField.text];
        [self.navigationController popViewControllerAnimated:YES];
    }];
}


@end
