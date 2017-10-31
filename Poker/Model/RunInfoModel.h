//
//  RunInfoModel.h
//  PKU
//
//  Created by ironfive on 16/8/10.
//  Copyright © 2016年 ironfive. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RunInfoModel : NSObject

@property (nonatomic,assign)long long time;

@property (nonatomic,assign)double distance;

@property (nonatomic,assign)long long speed;

@property (nonatomic,strong)NSData    *array;

@property (nonatomic,strong)NSData    *true_array;

@property (nonatomic,assign)NSInteger index;

@property (nonatomic,assign)Boolean   isver;

@property (nonatomic,assign)long long endtime;

@property (nonatomic,strong)NSString  *userid;

@property (nonatomic,strong)NSString  *photoFilename;

@property (nonatomic,strong)NSData  *imageData;

@end
