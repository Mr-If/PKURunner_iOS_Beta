//
//  RListTableViewCell.m
//  PKU
//
//  Created by ironfive on 16/8/10.
//  Copyright © 2016年 ironfive. All rights reserved.
//

#import "RListTableViewCell.h"

@implementation RListTableViewCell

-(void)awakeFromNib
{
    self.timelabel.layer.cornerRadius=3;
    self.timelabel.layer.masksToBounds=YES;
    self.timelabel.layer.borderColor=[UIColor colorFromHexString:@"#ff5d47"].CGColor;
    self.timelabel.backgroundColor=[UIColor colorFromHexString:@"#ff5d47"];
    self.timelabel.layer.borderWidth=1.0;
    
    self.photoBtn.layer.cornerRadius=14;
    self.photoBtn.layer.masksToBounds=YES;
    self.photoBtn.backgroundColor=[UIColor colorFromHexString:@"#ff5d47"];
    self.photoBtn.layer.borderWidth=1.0;
    
    self.verBtn.layer.cornerRadius=14;
    self.verBtn.layer.masksToBounds=YES;
    self.verBtn.backgroundColor=[UIColor colorFromHexString:@"#ff5d47"];
    self.verBtn.layer.borderWidth=1.0;
}


-(NSString *)getCurrentDate:(NSDate *)date
{
    
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday |
    NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    comps = [calendar components:unitFlags fromDate:date];
    
    NSLog(@"day-->%@---------weekday is %ld",[date description],[comps weekday]);//在这里需要注意的是：星期日是数字1，星期一时数字2，以此类推。。。
//    NSLog(@"-----------month is %d",[comps month]);
//    NSLog(@"-----------day is %d",[comps day]);
//    NSLog(@"-----------weekdayOrdinal is %d",[comps weekdayOrdinal]);

    
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *weekdayComponents = [gregorian components:NSCalendarUnitWeekday fromDate:date];
    NSInteger week = [weekdayComponents weekday];
//        week ++;
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
        case 8:
            weekDayStr = @"";
            break;
    }
    return weekDayStr;
}

-(void)setModel:(id)model
{
    _model=model;
    
    if ([model isKindOfClass:[RunInfo class]]) {
        RunInfo *m=(RunInfo *)model;
        
        NSLog(@"-->%@",[m.distance description]);
    
        NSDateFormatter *matter=[[NSDateFormatter alloc]init];
        [matter setDateFormat:@"dd"];
        NSDate *date=[NSDate dateWithTimeIntervalSince1970:[m.endtime longLongValue]];
        
        self.weekstr.text=[self getCurrentDate:date];
        
        self.timelabel.text=[NSString stringWithFormat:@"%@",[matter stringFromDate:date]];
        self.totallabel.text=[NSString stringWithFormat:@"%.2fkm",[m.distance integerValue]/1000.0];
        
        long long duration=[m.time longLongValue];
        NSString *startTime=[NSString stringWithFormat:@"%02lld:%02lld:%02lld",duration/60/60%24,duration/60%60,duration%60];
        self.timelabel_.text=startTime;
        
        double speed=[m.distance integerValue]/duration;
        NSInteger speed_time=1000/speed;
        self.speedlabel.text=[NSString stringWithFormat:@"%d'%d''",speed_time/60,speed_time%60];

        if (m.photoFilename.length<=0) {
            
            [self.photoBtn setTitle:@"照片未上传" forState:UIControlStateNormal];
            self.photoBtn.backgroundColor=[UIColor clearColor];
            self.photoBtn.layer.borderColor=[UIColor colorFromHexString:@"#ff5d47"].CGColor;
            self.photoBtn.layer.borderWidth=2.0;
            [self.photoBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

        }else{
            [self.photoBtn setTitle:@"照片已提交" forState:UIControlStateNormal];
            self.photoBtn.backgroundColor=[UIColor whiteColor];
            [self.photoBtn setTitleColor:[UIColor colorFromHexString:@"#ff5d47"] forState:UIControlStateNormal];
            
        }
       
        
        self.isverlabel.text=[m.step description];
        
        
        
        [self.verBtn setTitle:@"尚未上传" forState:UIControlStateNormal];
        self.verBtn.backgroundColor=[UIColor clearColor];
        self.verBtn.layer.borderColor=[UIColor colorFromHexString:@"#ff5d47"].CGColor;
        self.verBtn.layer.borderWidth=2.0;
        [self.verBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        self.photoBtn.enabled=YES;
        
    }else{
        
        NSString *day=[[[model objectForKey:@"date"] description] substringWithRange:NSMakeRange(8, 2)];
        
        NSDateFormatter *matter=[[NSDateFormatter alloc]init];
        [matter setDateFormat:@"yyyy-MM-dd"];
//        NSTimeZone* localzone = [NSTimeZone localTimeZone];
        NSTimeZone* GTMzone = [NSTimeZone timeZoneForSecondsFromGMT:0];
        [matter setTimeZone:GTMzone];
        NSString *dateStr=[[[model objectForKey:@"date"] description] substringToIndex:10];
        NSDate *date=[matter dateFromString:dateStr];
        
        self.weekstr.text=[self getCurrentDate:date];
        
        self.timelabel.text=[NSString stringWithFormat:@"%@",day];
        
        double distance=[[model objectForKey:@"distance"] doubleValue];
        self.totallabel.text=[NSString stringWithFormat:@"%.2fkm",distance/1000];
        
        NSInteger duration=[[model objectForKey:@"duration"] integerValue];
        NSString *startTime=[NSString stringWithFormat:@"%02d:%02d:%02d",duration/60/60%24,duration/60%60,duration%60];
        self.timelabel_.text=startTime;
        
        double speed=distance/duration;
        NSInteger speed_time=1000/speed;
        self.speedlabel.text=[NSString stringWithFormat:@"%d'%d''",speed_time/60,speed_time%60];
        
        NSPredicate *predicate=[NSPredicate predicateWithFormat:@"index==%d AND userid==%@", [[_model objectForKey:@"recordId"] integerValue],[UserInfoModel shareInstance].ids];
        
        LineInfo *info=[[LineInfo MR_findAllWithPredicate:predicate inContext:[NSManagedObjectContext MR_defaultContext]] lastObject];
        
        
        
        
        if ([[model objectForKey:@"photoPath"] description].length<=0) {
            [self.photoBtn setTitle:@"照片未上传" forState:UIControlStateNormal];
            self.photoBtn.backgroundColor=[UIColor clearColor];
            self.photoBtn.layer.borderColor=[UIColor colorFromHexString:@"#ff5d47"].CGColor;
            self.photoBtn.layer.borderWidth=2.0;
            [self.photoBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }else{
            
            [self.photoBtn setTitle:@"照片已上传" forState:UIControlStateNormal];
            self.photoBtn.backgroundColor=[UIColor whiteColor];
            [self.photoBtn setTitleColor:[UIColor colorFromHexString:@"#ff5d47"] forState:UIControlStateNormal];
            
        }
        
        if (info) {
            [self.photoBtn setTitle:@"照片已拍摄" forState:UIControlStateNormal];
            self.photoBtn.backgroundColor=[UIColor whiteColor];
            [self.photoBtn setTitleColor:[UIColor colorFromHexString:@"#ff5d47"] forState:UIControlStateNormal];
        }
        
        
         self.isverlabel.text=[[model objectForKey:@"step"] description];
        
        if ([[model objectForKey:@"verified"] boolValue]) {
            [self.verBtn setTitle:@"有效记录" forState:UIControlStateNormal];
            self.verBtn.backgroundColor=[UIColor colorFromHexString:@"#ff5d47"];
            [self.verBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }else{
            [self.verBtn setTitle:@"休闲记录" forState:UIControlStateNormal];
            self.verBtn.backgroundColor=[UIColor whiteColor];
            [self.verBtn setTitleColor:[UIColor colorFromHexString:@"#ff5d47"] forState:UIControlStateNormal];
        }
        
        self.photoBtn.enabled=NO;
        
    }
}

- (IBAction)ClickPhotoBtn:(id)sender {
    [self showAction];
}

-(void)showAction
{
    if (_photoDataBlock) {
        _photoDataBlock(_model);
    }
}

- (IBAction)ClickVerBtn:(id)sender {
    if (_verBlock) {
        _verBlock(_model);
    }
}

@end
