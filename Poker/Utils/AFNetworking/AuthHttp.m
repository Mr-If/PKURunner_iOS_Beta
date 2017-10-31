//
//  AuthHttp.m
//  PKU
//
//  Created by ironfive on 16/8/16.
//  Copyright © 2016年 ironfive. All rights reserved.
//

#import "AuthHttp.h"

@implementation AuthHttp

+(NSString *)fullUrlWith:(NSString *)str
{
    NSString *url=[NSString stringWithFormat:@"%@%@",@"",str];
    return url;
}

@end
