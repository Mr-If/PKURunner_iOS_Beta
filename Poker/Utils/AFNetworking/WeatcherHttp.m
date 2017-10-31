//
//  WeatcherHttp.m
//  PKU
//
//  Created by ironfive on 16/8/13.
//  Copyright © 2016年 ironfive. All rights reserved.
//

#import "WeatcherHttp.h"

@implementation WeatcherHttp

+(NSString *)fullUrlWith:(NSString *)str
{
    NSString *url=[NSString stringWithFormat:@"%@%@",@"",str];
    return url;
}
@end
