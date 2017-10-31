//
//  UserInfoModel.m
//  PKU
//
//  Created by ironfive on 16/8/10.
//  Copyright © 2016年 ironfive. All rights reserved.
//

#import "UserInfoModel.h"

@implementation UserInfoModel

+(instancetype)shareInstance
{
    static UserInfoModel *model=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        model=[[UserInfoModel alloc]init];
//        model.ids=@"1501212454";
//        model.token=@"6285740fa114adcde418252c628ce59b";
//        model.pwd=@"123456";
    });
    return model;
}

-(void)setDic:(NSDictionary *)dic
{
    
    dic=[dic objectForKey:@"data"];
    self.ids=[[dic objectForKey:@"id"] description];
    self.isPESpecialty=[[dic objectForKey:@"isPESpecialty"] boolValue];
    self.name=[[dic objectForKey:@"name"] description];
    self.sex=[[dic objectForKey:@"sex"] description];
    self.department=[[dic objectForKey:@"department"] description];
}

@end
