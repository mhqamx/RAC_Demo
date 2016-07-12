//
//  GFHTTPManger.h
//  oneWord
//
//  Created by goofygao on 5/12/16.
//  Copyright © 2016 goofyy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetWorkingBlock.h"
#import "AFNetworking.h"
@interface GFHTTPManger : NSObject

//+ (AFHTTPSessionManager *)manger;
/**
 *  请求头 token
 */
@property (nonatomic,copy) NSString *httpCookieToken;
/**
 *  GET请求
 *
 *  @param urlString    请求的url - 去除rootUrl
 *  @param parameters   参数
 *  @param responseKeys 返回的keys @[@"error",@"success"]
 *  @param autoRun      任务是否继续运行
 *  @param progress     进度
 *  @param completion   完成后的闭包
 *
 *  @return 当前任务task
 */
+ (NSURLSessionTask *)GET:(NSString *)urlString
                parameters:(NSDictionary *)parameters
              responseKeys:(id)responseKeys
                   autoRun:(BOOL)autoRun
                  progress:(GFNetProcessBlock)progress
                completion:(GFNetCompletionBlock)completion;


+ (NSURLSessionTask *)POST:(NSString *)urlString
               parameters:(NSDictionary *)parameters
             responseKeys:(id)responseKeys
                  autoRun:(BOOL)autoRun
                 progress:(GFNetProcessBlock)progress
               completion:(GFNetCompletionBlock)completion;
@end
