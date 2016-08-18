//
//  MXProjectMainViewController.m
//  RACDemo
//
//  Created by YISHANG on 16/8/18.
//  Copyright © 2016年 MAXIAO. All rights reserved.
//

#import "MXProjectMainViewController.h"
#import "MXProjectViewModel.h"
@interface MXProjectMainViewController ()
@property (nonatomic, strong) MXProjectViewModel  *viewModel;
@property (nonatomic, strong) UILabel  *resultLabel;
@end

@implementation MXProjectMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"MVVM";
    self.view.backgroundColor = [UIColor whiteColor];
    [self configUI];
    [self loadProjectViewModel];
}

- (void)configUI {
    self.resultLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 50, self.view.frame.size.width - 100, 50)];
    self.resultLabel.backgroundColor = [UIColor whiteColor];
    self.resultLabel.textColor = [UIColor blackColor];
    [self.view addSubview:self.resultLabel];
}

- (void)loadProjectViewModel {
    [self.viewModel.signal subscribeNext:^(id x) {
        NSLog(@"%s", __func__);
    } error:^(NSError *error) {
        self.resultLabel.text = @"RACSignal send Error";
        NSLog(@"%@", error);
    } completed:^{
        self.resultLabel.text = @"RACSignal send Completed";
        NSLog(@"completed");
    }];
}

- (MXProjectViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[MXProjectViewModel alloc] init];
    }
    return _viewModel;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
