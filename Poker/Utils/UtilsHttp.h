//
//  UtilsHttp.h
//  PKU
//
//  Created by ironfive on 16/8/16.
//  Copyright © 2016年 ironfive. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UtilsHttp : NSObject

+(void)getToken:(NSString *)phone withPwd:(NSString *)pwd withBlock:(void (^)(NSString *token))success withFaile:(void(^)(NSString *error))faile;

+(NSString *)getCurrentDate:(NSDate *)date;

@end
