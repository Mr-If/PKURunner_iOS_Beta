//
//  UtilsHttp.m
//  PKU
//
//  Created by ironfive on 16/8/16.
//  Copyright © 2016年 ironfive. All rights reserved.
//

#import "UtilsHttp.h"

@implementation UtilsHttp

+(void)getToken:(NSString *)phone withPwd:(NSString *)pwd withBlock:(void (^)(NSString *))success withFaile:(void (^)(NSString *))faile
{
       NSDictionary *params=@{@"appid":@"portal",@"userName":phone,@"password":pwd,@"redirUrl":@"http://portal.pku.edu.cn/portal2013/login.jsp/../ssoLogin.do"};
    
   [AuthHttp POST:@"https://iaaa.pku.edu.cn/iaaa/oauthlogin.do" parameters:params success:^(NSURLSessionDataTask *task, id jsonObject) {
        if ([jsonObject objectForKey:@"token"]) {
            [UserInfoModel shareInstance].token=[jsonObject objectForKey:@"token"];
            [UserInfoModel shareInstance].ids=phone;
            [UserInfoModel shareInstance].pwd=[MD5Encode md5HexDigest:pwd];
            success([[jsonObject objectForKey:@"token"] description]);
        }else{
       faile(@"");
   }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        faile(@"");
    }];

 }

+(NSString *)getCurrentDate:(NSDate *)date
{
        NSDateFormatter *matter=[[NSDateFormatter alloc]init];
        [matter setDateFormat:@"yyyy年MM月dd日"];
        //    NSDate *date=[NSDate date];
    NSTimeZone* GTMzone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    [matter setTimeZone:GTMzone];
    
        NSCalendar *gregorian = [[NSCalendar alloc]
                                 initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDateComponents *weekdayComponents = [gregorian components:NSCalendarUnitWeekday fromDate:date];
        NSInteger week = [weekdayComponents weekday];
//            week ++;
        NSString *weekDayStr=@"";
        switch (week) {
            case 1:
                weekDayStr = @"星期日";
                break;
            case 2:
                weekDayStr = @"星期一";
                break;
            case 3:
                weekDayStr = @"星期二";
                break;
            case 4:
                weekDayStr = @"星期三";
                break;
            case 5:
                weekDayStr = @"星期四";
                break;
            case 6:
                weekDayStr = @"星期五";
                break;
            case 7:
                weekDayStr = @"星期六";
                break;
            default:
                weekDayStr = @"";
                break;
        }
        return [NSString stringWithFormat:@"%@ %@", [matter stringFromDate:date],weekDayStr];
}

@end
