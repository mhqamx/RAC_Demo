//
//  MXMainViewController.m
//  RACDemo
//
//  Created by YISHANG on 16/7/15.
//  Copyright © 2016年 MAXIAO. All rights reserved.
//  利用RAC编写协议传值


#import "MXMainViewController.h"
#import "MXSecViewController.h"
#import <ReactiveCocoa.h>
@interface MXMainViewController ()<SendMessageDelegate>
@property (nonatomic, strong) UILabel  *msgLabel;
@end

@implementation MXMainViewController

- (UILabel *)msgLabel {
    if (!_msgLabel) {
        _msgLabel = [[UILabel alloc] initWithFrame:CGRectMake(200, 100, 100, 30)];
        _msgLabel.layer.borderColor = [UIColor redColor].CGColor;
        _msgLabel.layer.borderWidth = 1;
        _msgLabel.textColor = [UIColor blackColor];
    }
    return _msgLabel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"MXMainViewController";
    [self configUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    /**
     *  信号接收协议
     *  RAC替换Delegate感觉并不是很方便, 急需要设置代理对象, 也要签署协议, 但是对于那种有多重状态的情况下就比较方便了 , 直接可以switch来筛选就行, 看实际情况而定
     *  只是简化了一个步骤而已啊 
     */
    [[self rac_signalForSelector:@selector(sengMessage:) fromProtocol:@protocol(SendMessageDelegate)] subscribeNext:^(RACTuple *value) {
        self.msgLabel.text = value.first;
    }];
}

- (void)configUI {
    
    [self.view addSubview:self.msgLabel];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 100, 30)];
    button.backgroundColor = [UIColor redColor];
    [button setTitle:@"push" forState:(UIControlStateNormal)];
    [button setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [self.view addSubview:button];
    
    [[button rac_signalForControlEvents:(UIControlEventTouchUpInside)] subscribeNext:^(UIButton *sender) {
        sender.selected = !sender.selected;
        MXSecViewController *vc = [[MXSecViewController alloc] init];
        vc.kdelegate = self;
        [self.navigationController pushViewController:vc animated:YES];
    }];

}

- (void)sengMessage:(NSString *)msg {
    
}

@end
