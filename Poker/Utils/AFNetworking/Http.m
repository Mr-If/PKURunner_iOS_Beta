//
//  Http.m
//  QuerySystemApp
//
//  Created by ironfive on 15-1-25.
//  Copyright (c) 2015年 inphase. All rights reserved.
//

#import "Http.h"

@interface Http ()

@end

@implementation Http

+(AFHTTPSessionManager*) defaultManager {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
    requestSerializer.stringEncoding = UTF8Encoding;
    requestSerializer.timeoutInterval = TimeoutInterval;
    
    AFHTTPResponseSerializer *responseSerializer = [AFHTTPResponseSerializer serializer];
    responseSerializer.stringEncoding = UTF8Encoding;

    manager.requestSerializer = requestSerializer;
    manager.responseSerializer = responseSerializer;
    
    return manager;
}

+(NSURLSessionDataTask *)GET:(NSString *)URLString parameters:(id)parameters success:(void (^)(NSURLSessionDataTask *, id))success failure:(void(^)(NSURLSessionDataTask *, NSError *))failure{
    
    NSString *fullUrlString = [[self class] fullUrlWith:URLString];
    
    return [[[self class] defaultManager]GET:fullUrlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * task, id responseObject) {
        [[self class]handleWithOperation:task responseObject:responseObject success:success];
    } failure:^(NSURLSessionDataTask * task,NSError *error) {
        [[self class]failureHandleWithOperation:task error:error callBack:failure];
    }];
}

+(NSURLSessionDataTask *)POST:(NSString *)URLString parameters:(id)parameters success:(void (^)(NSURLSessionDataTask *task, id))success failure:(void (^)(NSURLSessionDataTask *, NSError *))failure{
    NSString *fullUrlString = [[self class] fullUrlWith:URLString];
    
    return [[self defaultManager]POST:fullUrlString parameters:parameters success:^(NSURLSessionDataTask *  task, id   responseObject) {
        [[self class]handleWithOperation:task responseObject:responseObject success:success];
    } failure:^(NSURLSessionDataTask *  task, NSError *  error) {
        failure(task,error);
    }];
}

+(NSURLSessionDataTask *)GETWithToken:(NSString *)URLString parameters:(id)parameters success:(void (^)(NSURLSessionDataTask *, id))success failure:(void (^)(NSURLSessionDataTask *, NSError *))failure{
    
    NSString *fullUrlString = [[self class] fullUrlWith:URLString];
    Class class = [self class];
    
    AFHTTPSessionManager *manager = [class defaultManager];
    NSMutableDictionary *mutalbleParameter = [NSMutableDictionary dictionaryWithDictionary:parameters];
    [class addTokenWithParameter:mutalbleParameter manager:manager];
    return [manager GET:fullUrlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * task, id responseObject) {
        [[self class]handleWithOperation:task responseObject:responseObject success:success];
    } failure:^(NSURLSessionDataTask * task,NSError *error) {
        failure(task,error);
    }];
}

+(NSURLSessionDataTask *)POSTWithToken:(NSString *)URLString parameters:(id)parameters success:(void (^)(NSURLSessionDataTask *, id))success failure:(void (^)(NSURLSessionDataTask *, NSError *))failure{
    
    NSString *fullUrlString = [[self class] fullUrlWith:URLString];
    Class class = [self class];
    AFHTTPSessionManager *manager = [class defaultManager];
    
    
    NSMutableDictionary *mutalbleParameter = [NSMutableDictionary dictionaryWithDictionary:parameters];
    [class addTokenWithParameter:mutalbleParameter manager:manager];
    
    return [manager POST:fullUrlString parameters:mutalbleParameter success:^(NSURLSessionDataTask *  task, id   responseObject) {
        id jsonObject = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
                success(task,jsonObject);
    } failure:^(NSURLSessionDataTask *  task, NSError *  error) {
        failure(task,error);
    }];
}

+(void) handleWithOperation:(NSURLSessionDataTask*)operation responseObject:(id) responseObject success:(void (^)(NSURLSessionDataTask *, id))success{
    NSError *error = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&error];
    
    if (error) {
        NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"error:%@,response:%@",error,responseString);
    }else {
            success(operation,jsonObject);
    }
}

+(NSURLSessionDataTask *)POST:(NSString *)URLString parameters:(id)parameters images:(NSArray *)images success:(void (^)(NSURLSessionDataTask *, id))success failure:(void (^)(NSURLSessionDataTask *, NSError *))failure{
    
    NSString *fullUrlString = [[self class] fullUrlWith:URLString];
    fullUrlString=[fullUrlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    Class class = [self class];
    AFHTTPSessionManager *manager = [class defaultManager];

    
    NSMutableDictionary *mutalbleParameter = [NSMutableDictionary dictionaryWithDictionary:parameters];
    [class addTokenWithParameter:mutalbleParameter manager:manager];
    
    return [manager POST:fullUrlString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        
        for (int i = 0; i < [images count]; i++) {
            UIImage *image = [images objectAtIndex:i];
            NSString *imageSuffix = @"jpg";
            NSData *imageData = UIImageJPEGRepresentation(image, 0.6);
            if (!imageData) {
                imageData = UIImagePNGRepresentation(image);
                imageSuffix = @"png";
            }
            
            [formData appendPartWithFileData:imageData name:@"photo" fileName:@"image.jpg" mimeType:@"image/jpeg"];
            
            
//            NSString *path=[[NSBundle mainBundle]pathForResource:@"test.jpg" ofType:nil];
            
//            [formData appendPartWithFileURL:[NSURL fileURLWithPath:path] name:@"file" fileName:@"image.jpg" mimeType:@"image/jpeg" error:nil];
        }
    } success:success failure:failure];
}

+(void) failureHandleWithOperation:(NSURLSessionDataTask*)operation error:(NSError*)error callBack:(void (^)(NSURLSessionDataTask *, NSError *))failure {
    NSString *errorString = [error.userInfo objectForKey:TimeoutErrorKey];
    if([errorString isEqualToString:TimeoutErrorValue]){
    }
    else if ([errorString isEqualToString:NetworkConnectLost]) {
    }
    failure(operation,error);
}

+(void)addTokenWithParameter:(NSMutableDictionary *)parameters manager:(AFHTTPSessionManager*)manager {
    
    NSString *token = [UserInfoModel shareInstance].token;
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"Authorization"];
}

+(NSString *)fullUrlWith:(NSString *)str
{
    NSString *url=[NSString stringWithFormat:@"%@%@",BASE_URL,str];
    return url;
}


@end
