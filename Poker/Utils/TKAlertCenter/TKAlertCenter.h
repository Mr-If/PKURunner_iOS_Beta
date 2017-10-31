//
//  TKAlertCenter.h
//  TKAlertCenter
//
//  Created by 123 on 16/1/6.
//  Copyright (c) 2016年 123. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TKAlertCenter : UIView

+(TKAlertCenter *)defaultCenter;
- (void) postAlertWithMessage:(NSString*)message image:(UIImage*)image;
- (void) postAlertWithMessage:(NSString *)message;

@end
