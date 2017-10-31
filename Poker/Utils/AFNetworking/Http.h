//
//  Http.h
//  QuerySystemApp
//
//  Created by ironfive on 15-1-25.
//  Copyright (c) 2015年 inphase. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AFNetworking.h"

#define UTF8Encoding NSUTF8StringEncoding
#define GBKEncoding CFStringConvertEncodingToNSStringEncoding(0x0632)
#define TimeoutInterval 20

#define JsonFormateError @"Json格式错误"
#define NetworkConnectFailure @"网络连接失败..."

#define TimeoutErrorKey @"NSLocalizedDescription"
#define TimeoutErrorValue @"The request timed out."
#define TimeoutErrorTintString @"网络连接超时"
#define NetworkConnectLost @"似乎已断开与互联网的连接。"
#define NetworkConnectLostTint @"请检查网络"



@interface Http : NSObject

+(AFHTTPSessionManager *)defaultManager;

+(NSURLSessionDataTask *)GET:(NSString *)URLString
                    parameters:(id)parameters
                       success:(void (^)(NSURLSessionDataTask *task, id jsonObject))success
                       failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

+(NSURLSessionDataTask *)POST:(NSString *)URLString
                     parameters:(id)parameters
                        success:(void (^)(NSURLSessionDataTask *task, id jsonObject))success
                        failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

+(NSURLSessionDataTask*)POSTWithToken:(NSString*)URLString
                             parameters:(id)parameters
                                success:(void (^)(NSURLSessionDataTask *task, id jsonObject))success
                                failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;
+(NSURLSessionDataTask*)GETWithToken:(NSString*)URLString
                            parameters:(id)parameters
                               success:(void (^)(NSURLSessionDataTask *task, id jsonObject))success
                               failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

+(NSURLSessionDataTask *)POST:(NSString *)URLString
                     parameters:(id)parameters
                         images:(NSArray*) images
                        success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                        failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;



@end
