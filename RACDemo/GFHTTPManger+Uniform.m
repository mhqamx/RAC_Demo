//
//  GFHTTPManger+Uniform.m
//  AiSenDe
//
//  Created by goofygao on 6/9/16.
//  Copyright © 2016 goofyy. All rights reserved.
//

#import "GFHTTPManger+Uniform.h"

@implementation GFHTTPManger (Uniform)

//+ (RACSignal *)rac_get:(NSString *)urlString params:(NSDictionary *)params {
//    return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
//        NSURLSessionTask *task = [self GET:urlString parameters:params responseKeys:nil autoRun:YES progress:nil completion:^(BOOL success, id userinfo) {
//            [subscriber sendNext:userinfo];
//            [subscriber sendCompleted];
//        }];
//        return [RACDisposable disposableWithBlock:^{
//            [task cancel];
//        }];
//    }] replayLazily];
//}
//
//
//+ (RACSignal *)rac_post:(NSString *)urlString params:(NSDictionary *)params {
//    return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
//        NSURLSessionTask *task = [self POST:urlString parameters:params responseKeys:nil autoRun:YES progress:nil completion:^(BOOL success, id userinfo) {
//            [subscriber sendNext:userinfo];
//            [subscriber sendCompleted];
//        }];
//        return [RACDisposable disposableWithBlock:^{
//            [task cancel];
//        }];
//    }] replayLazily];
//}

@end
