//
//  GFHTTPManger.m
//  oneWord
//
//  Created by goofygao on 5/12/16.
//  Copyright © 2016 goofyy. All rights reserved.
//

#import "GFHTTPManger.h"
//#import "GFNetworkingConst.h"

#define Manager  [AFHTTPSessionManager manager]

@implementation GFHTTPManger

+ (AFHTTPSessionManager *)manger {
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
//    [GFHTTPManger configHttpManger];
    return manger;
}

/**
 *  不知道这个方法对应的是什么
 */
//+ (NSString *)fullUrlString:(NSString *)urlString {
//    return [APIRootBsseURL stringByAppendingString:urlString];
//}

+ (void)configHttpManger {
    [self manger].responseSerializer = [AFJSONResponseSerializer serializer];
    [self manger].responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
}

- (void)setHttpCookieToken:(NSString *)httpCookieToken {
    if (httpCookieToken) {
        [[GFHTTPManger manger] setValue:httpCookieToken forKey:@"Authorization"];
    }
}

//+ (NSURLSessionTask *)GET:(NSString *)urlString
//               parameters:(NSDictionary *)parameters
//             responseKeys:(id)responseKeys
//                  autoRun:(BOOL)autoRun
//                  progress:(GFNetProcessBlock)progress
//                completion:(GFNetCompletionBlock)completion; {
//    AFHTTPSessionManager *manager = [GFHTTPManger manger];
//    NSURLSessionTask *task =
//    [manager GET:[GFHTTPManger fullUrlString:urlString]
//       parameters:parameters
//         progress:progress success:^(NSURLSessionTask *task, id response)
//     {
//         if ([response isKindOfClass:[NSArray class]]) {
//             
//             if (completion) completion(YES, response);
//             
//         } else if ([response isKindOfClass:[NSDictionary class]]) {
//             
//             if (response[@"response"] != nil) {
//                 
//                 if (responseKeys == nil) {
//                     
//                     if (completion) completion(YES, response);
//                 } else {
//                     
//                     if ([responseKeys isKindOfClass:[NSString class]]) {
//                         if (completion) completion(YES, response[responseKeys]);
//                         return;
//                     } else {
//                         
//                         NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//                         if ([responseKeys isKindOfClass:[NSArray class]]) {
//                             for (id key in responseKeys) {
//                                 [dict setObject:response[key] ? : @"" forKey:key];
//                             }
//                         } else if ([responseKeys isKindOfClass:[NSDictionary class]]) {
//                             for (id key in [responseKeys allKeys]) {
//                                 [dict setObject:response[key] forKey:responseKeys[key]];
//                             }
//                         }
//                         if (completion) completion(YES, dict);
//                     }
//                 }
//                 
//             } else {
//                 if (completion) completion(NO, response[@"error"]);
//             }
//         }
//         
//     } failure:^(NSURLSessionTask * task, NSError *error) {
//         if (completion) completion(NO, error);
//     }];
//    if(autoRun) [task resume];
//    return task;
//}
//
//
//+ (NSURLSessionTask *)POST:(NSString *)urlString
//               parameters:(NSDictionary *)parameters
//             responseKeys:(id)responseKeys
//                  autoRun:(BOOL)autoRun
//                 progress:(GFNetProcessBlock)progress
//               completion:(GFNetCompletionBlock)completion; {
//    AFHTTPSessionManager *manager = [GFHTTPManger manger];
//    NSURLSessionTask *task =
//    [manager POST:[GFHTTPManger fullUrlString:urlString]
//      parameters:parameters
//        progress:progress success:^(NSURLSessionTask *task, id response)
//     {
//         if ([response isKindOfClass:[NSArray class]]) {
//             
//             if (completion) completion(YES, response);
//             
//         } else if ([response isKindOfClass:[NSDictionary class]]) {
//             
////             if (response[@"response"] != nil) {
//             
//                 if (responseKeys == nil) {
//                     
//                     if (completion) completion(YES, response);
//                 } else {
//                     
//                     if ([responseKeys isKindOfClass:[NSString class]]) {
//                         if (completion) completion(YES, response[responseKeys]);
//                         return;
//                     } else {
//                         
//                         NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//                         if ([responseKeys isKindOfClass:[NSArray class]]) {
//                             for (id key in responseKeys) {
//                                 [dict setObject:response[key] ? : @"" forKey:key];
//                             }
//                         } else if ([responseKeys isKindOfClass:[NSDictionary class]]) {
//                             for (id key in [responseKeys allKeys]) {
//                                 [dict setObject:response[key] forKey:responseKeys[key]];
//                             }
//                         }
//                         if (completion) completion(YES, dict);
//                     }
//                 }
//                 
//             } else {
//                 if (completion) completion(NO, response[@"error"]);
//             }
////         }
//         
//     } failure:^(NSURLSessionTask * task, NSError *error) {
//         if (completion) completion(NO, error);
//     }];
//    if(autoRun) [task resume];
//    return task;
//}

@end
