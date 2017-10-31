//
//  CalendarViewController.m
//  PKU
//
//  Created by ironfive on 16/8/10.
//  Copyright © 2016年 ironfive. All rights reserved.
//

#import "CalendarViewController_.H"

#import "JTCalendar.h"

#import "ZZCircleProgress.h"

#import "RunInfoModel.h"

@interface CalendarViewController_ ()<JTCalendarDataSource,UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *procontentview;
@property (weak, nonatomic) IBOutlet UILabel *total;
@property (weak, nonatomic) IBOutlet UILabel *distime;
@property (weak, nonatomic) IBOutlet UILabel *runcountlabel;

@property (weak, nonatomic) IBOutlet JTCalendarMenuView *calendarMenuView;

@property (weak, nonatomic) IBOutlet JTCalendarContentView *calendarContentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *calend_height;

@property (strong, nonatomic) JTCalendar *calendar;

@property (nonatomic,strong)NSMutableArray                *rundata;

@property (nonatomic,strong)NSMutableArray                *dateData;

@property (nonatomic,strong)NSMutableArray                *checkData;

@property (nonatomic,assign)BOOL               run;

@property (nonatomic,assign)BOOL               check;

@property (nonatomic,assign)BOOL               date;

@property (nonatomic,copy)NSString             *tipdate;

@property (nonatomic,assign)NSInteger          runcount;

@property (nonatomic,strong)ZZCircleProgress   *pro;

@end

@implementation CalendarViewController_

- (void)viewDidLoad {
    [super viewDidLoad];

    self.calend_height.constant=CONTROL_WIDTH(300);
    
    float height=(SCREEN_WIDTH-10)/2.0;
    
    _pro = [[ZZCircleProgress alloc] initWithFrame:CGRectMake(0,0,height,height) pathBackColor:nil pathFillColor:[UIColor colorFromHexString:@"#EC6941"] startAngle:0 strokeWidth:10];
    
    _pro.center=CGPointMake(height/2.0, (SCREEN_HEIGHT-64-CONTROL_WIDTH(300))/2.0);
    _pro.total=0;
    _pro.finish_score=0;
    _pro.finish=0;
    _pro.showPoint = NO;
    _pro.animationModel = CircleIncreaseSameTime;
    _pro.progress = 0;
    [self.procontentview addSubview:_pro];
    
    
    self.calendar = [JTCalendar new];
    {
        self.calendar.calendarAppearance.calendar.firstWeekday = 2; // Sunday == 1, Saturday == 7
        self.calendar.calendarAppearance.dayCircleRatio = 9. / 10.;
        self.calendar.calendarAppearance.ratioContentMenu = 1.;
    }
    
    [self.calendar setMenuMonthsView:self.calendarMenuView];
    [self.calendar setContentView:self.calendarContentView];
    [self.calendar setDataSource:self];
    
    self.rundata=[NSMutableArray array];
    self.dateData=[NSMutableArray array];
    self.checkData=[NSMutableArray array];
    
    
    self.tipdate=@"2017-01-02";
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *endti=[dateFormatter dateFromString:self.tipdate];
    NSDate *currentDate=[NSDate date];
    NSTimeInterval time=[endti timeIntervalSinceDate:currentDate];
    NSInteger day=time/(3600*24);
    
//    self.total.text=[NSString stringWithFormat:@"打卡已进行了:%d次",0];
//    self.distime.text=[NSString stringWithFormat:@"距离提醒日还有:%d天",day];
    self.runcount=0;
//    self.runcountlabel.text=[NSString stringWithFormat:@"跑步次数:%d次",self.runcount];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.run=NO;
    self.check=NO;
    self.date=NO;
    
    self.runcount=0;
    [self loadRunData];
//    [self loadCheckData];
//    [self loadDateData];
//    [self loadData];
    
    [self loadRunProData];
    
    [self loadD];
}

-(void)loadD{
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"userid==%@",[UserInfoModel shareInstance].ids];
    
    NSArray *array=[RunInfo MR_findAllWithPredicate:predicate];
    
    NSMutableArray *infoarray=[NSMutableArray array];
    for(RunInfo *info in array) {
        RunInfoModel *model=[[RunInfoModel alloc]init];
        model.time=[info.time longLongValue];
        model.userid=info.userid;
        model.isver=[info.isver boolValue];
        model.distance=[info.distance longLongValue];
        model.speed=[info.speed longLongValue];
        model.array=info.array;
        model.endtime=[info.endtime longLongValue];
        model.index=[info.index integerValue];
        [infoarray addObject:model];
    }
    
    NSString *urlstr=[NSString stringWithFormat:@"record/%@",[UserInfoModel shareInstance].ids];
    [Http GETWithToken:urlstr parameters:nil success:^(NSURLSessionDataTask *task, id jsonObject) {
        
        if ([jsonObject objectForKey:@"data"]) {
            NSArray *array=[jsonObject objectForKey:@"data"];
            
            NSMutableArray *arr=[NSMutableArray array];
            
            NSMutableArray *total=[NSMutableArray array];
            [total addObjectsFromArray:infoarray];
            for (NSDictionary *dic in array) {
                BOOL have=NO;
                NSInteger recordId=[[dic objectForKey:@"recordId"] integerValue];
                for (RunInfoModel *model in total) {
                    if (model.index==recordId) {
                        have=YES;
                        break;
                    }
                }
                
                if (!have) {
                    [arr addObject:dic];
                }
                
            }
            [total addObjectsFromArray:arr];
            array=[total sortedArrayUsingComparator:^NSComparisonResult(id   obj1, id   obj2) {
                
                NSInteger ob;
                NSInteger obj;
                
                if ([obj1 isKindOfClass:[RunInfoModel class]]) {
                    RunInfoModel *model=(RunInfoModel *)obj1;
                    ob=model.index;
                }else{
                    ob=[[obj1 objectForKey:@"recordId"] integerValue];
                }
                
                if ([obj2 isKindOfClass:[RunInfoModel class]]) {
                    RunInfoModel *model=(RunInfoModel *)obj1;
                    obj=model.index;
                }else{
                    obj=[[obj2 objectForKey:@"recordId"] integerValue];
                }
                
                
                if (ob>obj) {
                    return NSOrderedAscending;
                }else{
                    return NSOrderedDescending;
                }
            }];
            
            
            self.runcountlabel.text=[NSString stringWithFormat:@"累计次数:%d",total.count];
            
            float distance=0;
            float time=0;
            for (id model in total) {
                if ([model isKindOfClass:[RunInfoModel class]]) {
                    RunInfoModel *m=(RunInfoModel *)model;
                    distance+=m.distance;
                    time+=m.time;
                }else{
                    distance+=([[model objectForKey:@"distance"] longLongValue]);
                    time+=([[model objectForKey:@"duration"] longLongValue]);
                }
            }
            
            self.total.text=[NSString stringWithFormat:@"累计距离:%.1fkm",distance/1000];
            self.total.adjustsFontSizeToFitWidth=YES;
            self.distime.text=[NSString stringWithFormat:@"累计时间:%.1fh",time/3600];
        }
        
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
    }];
    
}

-(void)loadRunProData
{
    NSDateFormatter *matter=[[NSDateFormatter alloc]init];
    [matter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *urlstr=[NSString stringWithFormat:@"record/status/%@",[UserInfoModel shareInstance].ids];
    [Http GETWithToken:urlstr parameters:nil success:^(NSURLSessionDataTask *task, id jsonObject) {
        [self dissmissHUD];
        if ([jsonObject objectForKey:@"data"]) {
            NSDictionary *data=[jsonObject objectForKey:@"data"];
            
            
            
            double target=[[data objectForKey:@"target"] doubleValue];
            double current=[[data objectForKey:@"current"] doubleValue];
            double bonus=[[data objectForKey:@"bonus"] doubleValue];
            
            double pro=current/target;
            double current_pro=pro>1.0?1.0:pro;
            
            self.pro.progress=current_pro;
            self.pro.finish=current;
            self.pro.finish_score=bonus;
            self.pro.total=target;
        }
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        //        [self showErrorHUD:@"加载失败,请稍后再试"];
        
    }];
}

//-(void)loadData
//{
//    NSDateFormatter *matter=[[NSDateFormatter alloc]init];
//    [matter setDateFormat:@"yyyy-MM-dd HH:mm"];
//    NSString *urlstr=[NSString stringWithFormat:@"record/%@",[UserInfoModel shareInstance].ids];
//    [Http GETWithToken:urlstr parameters:nil success:^(NSURLSessionDataTask *task, id jsonObject) {
//        
//        if ([jsonObject objectForKey:@"data"]) {
//            NSArray *array=[jsonObject objectForKey:@"data"];
//            self.runcount=array.count;
//            self.runcountlabel.text=[NSString stringWithFormat:@"跑步次数:%d次",self.runcount];
//        }
//    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        
//        
//    }];
//}

//-(void)loadDateData
//{
//    [AuthHttp GET:@"http://119.29.104.130/notice_date.php" parameters:nil success:^(NSURLSessionDataTask *task, id jsonObject) {
//        self.date=YES;
//        if([jsonObject objectForKey:@"notice_date"]){
//            self.tipdate=[jsonObject objectForKey:@"notice_date"];
//            NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
//            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
//            NSDate *endti=[dateFormatter dateFromString:self.tipdate];
//            NSDate *currentDate=[NSDate date];
//            NSTimeInterval time=[endti timeIntervalSinceDate:currentDate];
//            NSInteger day=time/(3600*24);
//            self.distime.text=[NSString stringWithFormat:@"距离体测还有:%d天",day];
//        }
//        
//        
//        [self.calendar reloadData];
//        if (self.check&&self.run&&self.date) {
//            [self dissmissHUD];
//            
//        }
//    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        self.date=YES;
//        if (self.check&&self.run&&self.date) {
//            [self dissmissHUD];
//        }
//    }];
//}

-(void)loadRunData
{
    NSString *urlstr=[NSString stringWithFormat:@"record/%@",[UserInfoModel shareInstance].ids];
    [Http GETWithToken:urlstr parameters:nil success:^(NSURLSessionDataTask *task, id jsonObject) {
        
        self.run=YES;
        
        if ([jsonObject objectForKey:@"data"]) {
            [self.rundata removeAllObjects];
            [self.dateData removeAllObjects];
            [self.rundata addObjectsFromArray:[jsonObject objectForKey:@"data"]];
            float distance=0.0;
            for (NSDictionary *dic in self.rundata) {
                NSString *str=[[dic objectForKey:@"date"] substringToIndex:10];
                float du=[[dic objectForKey:@"distance"] floatValue];
                distance+=du;
                
                [self.dateData addObject:str];
            }
            distance=distance/1000;
            
            /*if ([[UserInfoModel shareInstance].sex isEqualToString:@"女"]) {
               distance=distance/80;
                [self.pro setProgress:distance Animated:YES];
                [self.pro setTotal:distance*80 Animated:NO];
            }else{
                distance=distance/100;
                [self.pro setProgress:distance Animated:YES];
                [self.pro setTotal:distance*100 Animated:NO];
            }*/
            [self.calendar reloadData];
        }
        
        if (self.check&&self.run&&self.date) {
            [self dissmissHUD];
//            [self.calendar reloadData];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        self.run=YES;
        if (self.check&&self.run&&self.date) {
            [self dissmissHUD];
        }
    }];
}

//-(void)loadCheckData
//{
//    NSString *url=[NSString stringWithFormat:@"record2/%@",[UserInfoModel shareInstance].ids];
//    [Http GETWithToken:url parameters:nil success:^(NSURLSessionDataTask *task, id jsonObject) {
//        self.check=YES;
//        
//        if ([jsonObject objectForKey:@"data"]) {
//            NSArray *array=[jsonObject objectForKey:@"data"];
//            self.total.text=[NSString stringWithFormat:@"打卡已进行了:%d次",array.count];
//            [self.checkData removeAllObjects];
//            for (NSDictionary *dic in array) {
//                NSString *str=[[dic objectForKey:@"startTime"] substringToIndex:10];
//                
//                [self.checkData addObject:str];
//            }
//        }
//        [self.calendar reloadData];
//        if (self.check&&self.run&&self.date) {
//            [self dissmissHUD];
////            [self.calendar reloadData];
//        }
//        
//    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        self.check=YES;
//        if (self.check&&self.run&&self.date) {
//            [self dissmissHUD];
//        }
//    }];
//}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.calendar setCurrentDate:[NSDate date]];
    [self.calendar reloadData]; // Must be call in viewDidAppear
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.calendarContentView removeFromSuperview];
    [self.calendarMenuView removeFromSuperview];
}

- (BOOL)calendarHaveEvent:(JTCalendar *)calendar date:(NSDate *)date
{
//    return (rand() % 10) == 1;
    
    NSDateFormatter *matter=[[NSDateFormatter alloc]init];
    [matter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *dateStr=[matter stringFromDate:date];
    if ([dateStr isEqualToString:self.tipdate]) {
        return YES;
    }
    
    return NO;
}

/*
 0表示隐藏
 1表示有跑步记录
 2表示有打卡记录
 3.表示跑步＋打卡都存在
*/

-(NSInteger)calendarHaveEventKuaiHidden:(JTCalendar *)calendar date:(NSDate *)date
{
    NSDateFormatter *matter=[[NSDateFormatter alloc]init];
    [matter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *dateStr=[matter stringFromDate:date];
    
    NSString *todaystr=[matter stringFromDate:[NSDate date]];
    
    if ([dateStr isEqualToString:todaystr]) {
//        return YES;
        return 0;
    }
//    }else if ([dateStr isEqualToString:@"2016-08-13"]){
//        return NO;
//    }
    
    if ([self.dateData containsObject:dateStr]&&[self.checkData containsObject:dateStr]) {
        return 3;
    }
    
    if ([self.dateData containsObject:dateStr]&&![self.checkData containsObject:dateStr]) {
        return 1;
    }
    
    if ([self.checkData containsObject:dateStr]&&![self.dateData containsObject:dateStr]) {
        return 2;
    }
    return 0;
}

- (void)calendarDidDateSelected:(JTCalendar *)calendar date:(NSDate *)date
{
//    NSLog(@"Date: %@", date);
//    
//    UIAlertView *alertview=[[UIAlertView alloc]initWithTitle:@"提示" message:@"确认设置为提醒日?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//    [alertview show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {
        [self.calendar reloadData];
    }
}

@end
