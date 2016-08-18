//
//  MXProjectViewModel.h
//  RACDemo
//
//  Created by YISHANG on 16/8/18.
//  Copyright © 2016年 MAXIAO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa.h>
@class MXProjectModel;
@interface MXProjectViewModel : NSObject
@property (nonatomic, strong) MXProjectModel  *model;
@property (nonatomic, strong) RACSignal  *signal;

- (void)testMethod;

@end
