//
//  UserInfoModel.h
//  PKU
//
//  Created by ironfive on 16/8/10.
//  Copyright © 2016年 ironfive. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfoModel : NSObject

+(instancetype)shareInstance;

@property (nonatomic,strong)NSString  *ids;

@property (nonatomic,copy)NSString    *phone;

@property (nonatomic,copy)NSString    *pwd;

@property (nonatomic,strong)NSString  *token;

@property (nonatomic,strong)NSString  *sex;

@property (nonatomic,strong)NSString  *department;

@property (nonatomic,strong)NSString  *name;

@property (nonatomic,assign)Boolean    isPESpecialty;


-(void)setDic:(NSDictionary *)dic;

@end
