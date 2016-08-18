//
//  MXHomePageViewController.m
//  RACDemo
//
//  Created by YISHANG on 16/7/19.
//  Copyright © 2016年 MAXIAO. All rights reserved.
//

#import "MXHomePageViewController.h"
#import "ViewController.h"
#import "MXMainViewController.h"
#import "MXReviewViewController.h"
#import "MXMethodsViewController.h"
#import "MXProjectMainViewController.h"
@interface MXHomePageViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView  *mainTableView;
@property (nonatomic, strong) NSArray  *dataArr;

@end

@implementation MXHomePageViewController

#pragma mark - lazyInitlization

- (UITableView *)mainTableView {
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:(UITableViewStylePlain)];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
    }
    return _mainTableView;
}

-(NSArray *)dataArr {
    return @[@"知识点", @"RAC协议传值", @"复习", @"方法", @"MVVM"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
}

- (void)configUI {
    [self.view addSubview:self.mainTableView];
}

#pragma mark ---------- UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *tag = @"mainTableView";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tag];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:tag];
    }
    cell.textLabel.text = self.dataArr[indexPath.section];
    return cell;
}

#pragma mark ---------- UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.dataArr.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
            [self.navigationController pushViewController:[ViewController new] animated:YES];
            break;
        case 1:
            [self.navigationController pushViewController:[MXMainViewController new] animated:YES];
            break;
        case 2:
            [self.navigationController pushViewController:[MXReviewViewController new] animated:YES];
            break;
        case 3:
            [self.navigationController pushViewController:[MXMethodsViewController new] animated:YES];
            break;
        case 4:
            [self.navigationController pushViewController:[MXProjectMainViewController new] animated:YES];
            break;
        default:
            break;
    }
}


@end
