//
//  MXSecViewController.h
//  RACDemo
//
//  Created by YISHANG on 16/7/15.
//  Copyright © 2016年 MAXIAO. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SendMessageDelegate <NSObject>

- (void)sengMessage:(NSString *)msg;

@end

@interface MXSecViewController : UIViewController
@property (nonatomic, assign) id<SendMessageDelegate> kdelegate;
@end
