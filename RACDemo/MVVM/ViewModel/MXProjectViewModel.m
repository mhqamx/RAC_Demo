//
//  MXProjectViewModel.m
//  RACDemo
//
//  Created by YISHANG on 16/8/18.
//  Copyright © 2016年 MAXIAO. All rights reserved.
//

#import "MXProjectViewModel.h"

@implementation MXProjectViewModel

- (void)testMethod {
    NSLog(@"%s", __func__);
}

- (RACSignal *)signal {
    if (!_signal) {
        _signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            
            [subscriber sendNext:@"start"];
            // 在这里来请求网络或者一些逻辑判断
            // 我直接设置了一个随机数来判断signal是否sendCompleted
            NSInteger value;
            value = random() % 5;
            NSLog(@"%ld", value);
            if (value >= 3) {
                [subscriber sendCompleted];
            } else {
                NSError *error;
                [subscriber sendError:error];
            }
            return [RACDisposable disposableWithBlock:^{
                
            }];
            
        }];
    }
    return _signal;
}

@end
