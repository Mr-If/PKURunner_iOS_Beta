//
//  RunViewController.m
//  PKU
//
//  Created by ironfive on 16/8/9.
//  Copyright © 2016年 ironfive. All rights reserved.
//

#import "RunViewController.h"

#import "MyPointAnnotation.h"

#import "RunDetailViewController.h"

#import "MAMutablePolyline.h"
#import "MAMutablePolylineRenderer.h"

#import <AVFoundation/AVFoundation.h>

#import <AudioToolbox/AudioToolbox.h>

#import "RListViewController.h"

#import <CoreMotion/CoreMotion.h>

@interface RunViewController ()<MAMapViewDelegate,UIAlertViewDelegate,UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet MAMapView *mapview;

@property (weak, nonatomic) IBOutlet UIButton *btu_left;

@property (weak, nonatomic) IBOutlet UIButton *btu_center;

@property (weak, nonatomic) IBOutlet UIButton *btu_right;

@property (weak, nonatomic) IBOutlet UILabel *totallabel;

@property (weak, nonatomic) IBOutlet UILabel *timelabel;

@property (weak, nonatomic) IBOutlet UILabel *speedlabel;
@property (weak, nonatomic) IBOutlet UIView *topview;
@property (weak, nonatomic) IBOutlet UILabel *currentTimeLabel;

@property (nonatomic,strong)NSTimer          *timer;

@property (nonatomic,strong)UILabel          *antimelabel;

@property (nonatomic,strong)NSDate          *startDate;

@property (nonatomic,strong)NSDate          *endDate;

@property (nonatomic,strong)UIView *anview;

@property (nonatomic,assign)long        timecount;

@property (nonatomic,strong)NSMutableArray   *locatedline;

@property (nonatomic,strong)NSMutableArray   *tureline;

@property (nonatomic,strong)MAMutablePolyline       *polyline;

@property (nonatomic, strong) MAMutablePolylineRenderer *mutableView;

@property (nonatomic,assign)BOOL             runing;

@property (nonatomic,assign)BOOL             ispause;

@property (nonatomic,assign)NSInteger        step;

@property (nonatomic,strong)AVAudioPlayer   *startplayer;

@property (nonatomic,strong)AVAudioPlayer    *continueplayer;

@property (nonatomic,strong)AVAudioPlayer    *pauseplayer;

@property (nonatomic,assign)SystemSoundID     startID;

@property (nonatomic,assign)SystemSoundID     continueID;

@property (nonatomic,assign)SystemSoundID     pauseID;

@property (nonatomic,strong)CMPedometer       *pedomenter;

@property (nonatomic,strong)CMMotionManager  *motionManager;

@end

@implementation RunViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"运动";
    
    _motionManager=[[CMMotionManager alloc]init];
    [self startUpdateAccelerometer];
    
    self.topview.layer.cornerRadius=10;
    self.topview.layer.masksToBounds=YES;
    _mapview.showsUserLocation=YES;
    _mapview.delegate=self;
    _mapview.showsScale=NO;
    _mapview.showsCompass=NO;
    _mapview.distanceFilter=10;
    _mapview.zoomLevel=16;
    _mapview.rotateEnabled=NO;
    _mapview.rotateCameraEnabled=NO;
    _mapview.desiredAccuracy=kCLLocationAccuracyBest;
    _mapview.logoCenter=CGPointMake(SCREEN_WIDTH-_mapview.logoSize.width/2.0, SCREEN_HEIGHT-80);
    
    _mapview.pausesLocationUpdatesAutomatically = NO;
    
    _mapview.allowsBackgroundLocationUpdates = YES;//iOS9以上系统必须配置
    
    self.polyline=[[MAMutablePolyline alloc]initWithPoints:@[]];
    
    
    self.totallabel.text=@"0.00km";
    self.timelabel.text=@"00:00:00";
    self.speedlabel.text=@"0'00''";
    
    self.btu_left.layer.cornerRadius=8;
    self.btu_left.layer.masksToBounds=YES;
    
    self.btu_center.layer.cornerRadius=10;
    self.btu_center.layer.masksToBounds=YES;
    
    self.btu_right.layer.cornerRadius=10;
    self.btu_right.layer.masksToBounds=YES;
    
    self.timecount=0;
    
    
    self.locatedline=[NSMutableArray array];
    self.tureline=[NSMutableArray array];
    
    [self.mapview addOverlay:self.polyline];
    

    [_mapview setUserTrackingMode:MAUserTrackingModeFollow];
    
    
    [self anima];
    
    self.currentTimeLabel.text=[UtilsHttp getCurrentDate:[NSDate date]];
}


-(void)InitMedia{
    NSString *runpath=[[NSBundle mainBundle]pathForResource:@"start" ofType:@"wav"];
    NSURL *runurl=[NSURL fileURLWithPath:runpath];
    
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)(runurl), &_startID);
    
    _startplayer=[[AVAudioPlayer alloc]initWithContentsOfURL:runurl error:nil];
    
    
    NSString *pausepath=[[NSBundle mainBundle]pathForResource:@"pause" ofType:@"wav"];
    NSURL *pauseurl=[NSURL fileURLWithPath:pausepath];
    
    _pauseplayer=[[AVAudioPlayer alloc]initWithContentsOfURL:pauseurl error:nil];
    
    
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)(pauseurl), &_pauseID);
    
    
    
    NSString *continuepath=[[NSBundle mainBundle]pathForResource:@"continue" ofType:@"wav"];
    NSURL *continueurl=[NSURL fileURLWithPath:continuepath];
    
    _continueplayer=[[AVAudioPlayer alloc]initWithContentsOfURL:continueurl error:nil];
    
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)(continueurl), &_continueID);
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    _mapview.delegate=nil;
    [RunViewController cancelLocalNotificationWithKey:@"key"];
    [_motionManager stopAccelerometerUpdates];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}


-(void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation
{
    if(updatingLocation)
    {
        //取出当前位置的坐标
        if (_runing) {
            //40
            if (userLocation.location.horizontalAccuracy < 40 && userLocation.location.horizontalAccuracy > 0) {
            
                if (_ispause) {
                  [self.polyline appendPoint:MAMapPointForCoordinate(CLLocationCoordinate2DMake(180, 180))];
                    _ispause=NO;
                    
                    CLLocation *located=[self.locatedline lastObject];
                    
                    if (located.coordinate.latitude!=180||located.coordinate.longitude!=180) {
                        
                        [self.tureline addObject:@[@(located.coordinate.longitude),@(located.coordinate.latitude),@(2)]];
                    }
                    CLLocation *located1=[[CLLocation alloc]initWithLatitude:180 longitude:180];
                    [self.locatedline addObject:located1];
                }
            
            [self.polyline appendPoint:MAMapPointForCoordinate(userLocation.location.coordinate)];
            [self.locatedline addObject:userLocation.location];
          [self.tureline addObject:@[@(userLocation.location.coordinate.longitude),@(userLocation.location.coordinate.latitude)]];
                
                
            [self getspeed];

            
            
                [self.mutableView referenceDidChange];
                static dispatch_once_t onceToken;
                dispatch_once(&onceToken, ^{
                    MyPointAnnotation *annotation=[[MyPointAnnotation alloc]init];
                    annotation.coordinate=userLocation.location.coordinate;
                    annotation.isstart=YES;
                    [_mapview addAnnotation:annotation];
                });
            }
        }
        
        if (self.locatedline.count<=0) {
            
            [self.mapview setCenterCoordinate:userLocation.location.coordinate animated:YES];
        }
    }
}

-(void)getspeed
{
    double dis=0;
        
        NSMutableArray *array=[NSMutableArray array];
        NSMutableArray *total=[NSMutableArray array];
        [total addObject:array];

        for (int i=0;i<self.mutableView.mutablePolyline.pointArray.count;i++) {
            NSValue *value=[self.mutableView.mutablePolyline.pointArray objectAtIndex:i];
            MAMapPoint po= [value MAMapPointValue];
            if (po.x==268435456&&po.y==134217728) {
                array =[NSMutableArray array];
                [total addObject:array];
                continue;
            }
            [array addObject:value];
        }
        
        for (NSMutableArray *ar in total) {
            
            if (ar.count>2) {
                for (int i=0; i<ar.count; i++) {
                    if (i<ar.count-1) {
                        
                        NSValue *value=[ar objectAtIndex:i];
                        NSValue *value1=[ar objectAtIndex:i+1];
                        MAMapPoint point1= [value MAMapPointValue];
                        MAMapPoint point2= [value1 MAMapPointValue];
                        //2.计算距离
                        CLLocationDistance distance = MAMetersBetweenMapPoints(point1,point2);
                        dis+=distance;
                    }
                }
            }
        
        double speed=dis/_timecount;
        NSInteger speed_time=1000/speed;
        
        self.speedlabel.text=[NSString stringWithFormat:@"%d'%02d''",speed_time/60,speed_time%60];
        
        self.totallabel.text=[NSString stringWithFormat:@"%.2f",dis/1000];
    }
}

- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id <MAOverlay>)overlay
{
    if ([overlay isKindOfClass:[MAMutablePolyline class]])
    {
        MAMutablePolylineRenderer *polylineRenderer = [[MAMutablePolylineRenderer alloc] initWithMutablePolyline:overlay withDetail:NO];
        polylineRenderer.lineWidth    = 8.f;
        polylineRenderer.strokeColor  = [UIColor colorWithRed:0 green:1 blue:0 alpha:0.6];
        polylineRenderer.lineJoinType = kMALineJoinRound;
        polylineRenderer.lineCapType  = kMALineCapRound;
        _mutableView = polylineRenderer;
        return polylineRenderer;
    }
    return nil;
}



-(MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MyPointAnnotation class]])
    {
        MyPointAnnotation *an=(MyPointAnnotation *)annotation;
        
        static NSString *reuseIndetifier = @"annotationReuseIndetifier";
        MAAnnotationView *annotationView = (MAAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation
                                                          reuseIdentifier:reuseIndetifier];
        }
        
        if (an.isstart) {
             annotationView.image = [UIImage imageNamed:@"starticon"];
        }else{
             annotationView.image = [UIImage imageNamed:@"stopicon"];
        }
        //设置中心点偏移，使得标注底部中间点成为经纬度对应点
        annotationView.centerOffset = CGPointMake(0, -12);
        return annotationView;
    }
    return nil;
}


-(void)anima
{
    _anview=[[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    _anview.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    _antimelabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 300, 300)];
    _antimelabel.center=CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
    _antimelabel.textAlignment=NSTextAlignmentCenter;
    _antimelabel.text=@"4";
    _antimelabel.hidden=YES;
    _antimelabel.textColor=[UIColor whiteColor];
    _antimelabel.font=[UIFont systemFontOfSize:100.0f];
    [_anview addSubview:_antimelabel];
    
    [self.view addSubview:_anview];
    
    _antimelabel.transform=CGAffineTransformIdentity;
    [UIView animateWithDuration:.9 animations:^{
        _antimelabel.transform=CGAffineTransformScale(_antimelabel.transform, 2.0, 2.0);
    }];
    
    _timer=[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(ChangeTime:) userInfo:nil repeats:YES];
}

-(void)ChangeTime:(NSTimer *)timer
{
    int value=[_antimelabel.text intValue];
    _antimelabel.hidden=NO;
    value--;
    if (value<=0) {
        [self endTime];
        [_anview removeFromSuperview];
        [self startTime];
        _ispause=NO;
        [_startplayer play];
        AudioServicesPlaySystemSound(_startID);
        return;
    }
    _antimelabel.text=[NSString stringWithFormat:@"%d",value];
    _antimelabel.transform=CGAffineTransformIdentity;
    [UIView animateWithDuration:.9 animations:^{
        _antimelabel.transform=CGAffineTransformScale(_antimelabel.transform, 2.0, 2.0);
    }];
}

-(void)startTime
{
    
 _runing=YES;
 _timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(RunTime:) userInfo:nil repeats:YES];
      [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    
//    [self performSelector:@selector(ShowAlertview) withObject:nil afterDelay:2*3600];
}

-(void)ShowAlertview
{
    if (_runing) {
        UIAlertView *aertview=[[UIAlertView alloc]initWithTitle:@"提示" message:@"您已经连续跑步两小时了" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [aertview show];
    }
}

-(void)endTime
{
    _runing=NO;
    [_timer invalidate];
    _timer=nil;
}

-(void)RunTime:(NSTimer *)timer
{
    _timecount++;
    
    //_timecount==2*3600
    if(_timecount==2*3600){
        [RunViewController registerLocalNotification:1];
    }
    
    NSString *startTime=[NSString stringWithFormat:@"%02ld:%02ld:%02ld",_timecount/60/60%24,_timecount/60%60,_timecount%60];
    self.timelabel.text=startTime;
}

// 设置本地通知
+ (void)registerLocalNotification:(NSInteger)alertTime {
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    // 设置触发通知的时间
    NSDate *fireDate = [NSDate dateWithTimeIntervalSinceNow:alertTime];
    NSLog(@"fireDate=%@",fireDate);
    
    notification.fireDate = fireDate;
    // 时区
    notification.timeZone = [NSTimeZone defaultTimeZone];
    // 设置重复的间隔
    notification.repeatInterval = kCFCalendarUnitSecond;
    
    // 通知内容
    notification.alertBody =  @"您已经连续跑步两小时了";
    notification.applicationIconBadgeNumber = 1;
    // 通知被触发时播放的声音
    notification.soundName = UILocalNotificationDefaultSoundName;
    // 通知参数
    NSDictionary *userDict = [NSDictionary dictionaryWithObject:@"您已经连续跑步两小时了" forKey:@"key"];
    notification.userInfo = userDict;
    
    // ios8后，需要添加这个注册，才能得到授权
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationType type =  UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:type
                                                                                 categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        // 通知重复提示的单位，可以是天、周、月
        notification.repeatInterval = NSCalendarUnitDay;
    } else {
        // 通知重复提示的单位，可以是天、周、月
        notification.repeatInterval = NSDayCalendarUnit;
    }
    
    // 执行通知注册
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}

// 取消某个本地推送通知
+ (void)cancelLocalNotificationWithKey:(NSString *)key {
    // 获取所有本地通知数组
    NSArray *localNotifications = [UIApplication sharedApplication].scheduledLocalNotifications;
    
    for (UILocalNotification *notification in localNotifications) {
        NSDictionary *userInfo = notification.userInfo;
        if (userInfo) {
            // 根据设置通知参数时指定的key来获取通知参数
            NSString *info = userInfo[key];
            
            // 如果找到需要取消的通知，则取消
            if (info != nil) {
                [[UIApplication sharedApplication] cancelLocalNotification:notification];
                break;
            }
        }
    }
}


- (IBAction)ClickLeftBtu:(id)sender {
    _mapview.centerCoordinate=_mapview.userLocation.location.coordinate;
    _mapview.zoomLevel=16;
}

- (IBAction)ClickCenterBtu:(UIButton *)sender {
    sender.selected=!sender.selected;
    if (sender.selected) {
        [_pauseplayer play];
         AudioServicesPlaySystemSound(_pauseID);
        _ispause=YES;
        [self endTime];
    }else{
        [_continueplayer play];
         AudioServicesPlaySystemSound(_continueID);
        [self startTime];
        _startDate=[NSDate date];
    }
}

- (IBAction)ClickRightBtu:(id)sender {
    [self endTime];
   /*
    float lat=30.5;
    float lon=104.1;
    

    
    
    for (int i=0; i<10; i++) {
        lat+=0.1;
        lon+=0.1;
        CLLocation *location=[[CLLocation alloc]initWithLatitude:lat longitude:lon];
        [self.locatedline addObject:location];
        
        [self.tureline addObject:@[@(lon),@(lat)]];
    }*/
    
    if (self.locatedline.count<2) {
        UIActionSheet *sheet=[[UIActionSheet alloc]initWithTitle:@"此次运动距离太短,无法保存,是否结束本次运动" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"结束运动" otherButtonTitles:nil, nil];
        [sheet showInView:self.view];
        
        return;
    }
    
    [self showAlert];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        [self endTime];
        [self dismissViewControllerAnimated:YES completion:NULL];
    }else{
        [self startTime];
    }
}

-(void)showAlert
{
//    UIAlertView *alertview=[[UIAlertView alloc]initWithTitle:@"请输入传输密码" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//    [alertview setAlertViewStyle:UIAlertViewStyleSecureTextInput];
//    UITextField *nameField = [alertview textFieldAtIndex:0];
//    nameField.textAlignment=NSTextAlignmentCenter;
//    alertview.tag=2016;
//    [alertview show];
    
    UIAlertView *alertview=[[UIAlertView alloc]initWithTitle:@"提示" message:@"真的要结束跑步吗" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
//    [alertview setAlertViewStyle:UIAlertViewStyleSecureTextInput];
    UITextField *nameField = [alertview textFieldAtIndex:0];
    nameField.textAlignment=NSTextAlignmentCenter;
    alertview.tag=2016;
    [alertview show];
}

-(void)showal
{
    UIAlertView *alertview=[[UIAlertView alloc]initWithTitle:@"提示" message:@"是否放弃保存此次纪录?" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
    alertview.tag=2017;
    [alertview show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (alertView.tag==2016) {
        if (buttonIndex==1) {
            [self performSelector:@selector(showDetailCtrl) withObject:nil afterDelay:.5];
        }else{
            [self startTime];
        }
    }else if(alertView.tag==2017){
        if (buttonIndex==0) {
            [self performSelector:@selector(showAlert) withObject:nil afterDelay:.5];
        }else{
            [self dismissViewControllerAnimated:YES completion:NULL];
        }
    }
    [alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
}

-(void)showErrorHUD{
    [self showToast:@"传输密码错误"];
}

- (void)startUpdateAccelerometer
{
    NSTimeInterval updateInterval = 1.0;
    if ([_motionManager isAccelerometerAvailable] == YES) {
        [_motionManager setAccelerometerUpdateInterval:updateInterval];
        [_motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:^(CMAccelerometerData *accelerometerData, NSError *error)
         {
             
             CGFloat sqrtValue =sqrt(accelerometerData.acceleration.x*accelerometerData.acceleration.x+accelerometerData.acceleration.y*accelerometerData.acceleration.y+accelerometerData.acceleration.z*accelerometerData.acceleration.z);
             
             
             NSLog(@"-->%.5f",sqrtValue);
             
             if (sqrtValue > 1.552188&&!_ispause)
             {
                 _step++;
             }
             
         }];
    }
    
} 


-(void)showDetailCtrl{
    
  
    
    
    NSInteger dis=[self.totallabel.text doubleValue]*1000;
    
  //---------
//    self.step=100;
//    self.timecount=100;
//    dis=1000;
    
    //----------
    
    RunInfo *model=[RunInfo MR_createEntity];
    model.time=[NSNumber numberWithDouble:_timecount];
    
    
    model.distance=[NSNumber numberWithInteger:dis];
    model.speed=[NSNumber numberWithInteger:dis/_timecount/100/60];
    
    long index=[[NSDate date] timeIntervalSince1970];
    
    model.index=[NSNumber numberWithInteger:index];
    model.isver=[NSNumber numberWithBool:NO];
    model.endtime=[NSNumber numberWithLong:[[NSDate date] timeIntervalSince1970]];
    model.userid=[UserInfoModel shareInstance].ids;
    model.step=@(_step);
    NSData *array=[NSKeyedArchiver archivedDataWithRootObject:self.locatedline];
    model.array=array;
    NSData *tureArray=[NSKeyedArchiver archivedDataWithRootObject:self.tureline];
    model.tureline=tureArray;
    [[NSManagedObjectContext MR_defaultContext]MR_saveOnlySelfAndWait];
    
    RListViewController *ctrl=[[RListViewController alloc]initWithStyle:UITableViewStylePlain];
    ctrl.hidesBottomBarWhenPushed=YES;
    [[AppDelegate shareInstance].startNav pushViewController:ctrl animated:YES];
    
    
    [self dismissViewControllerAnimated:NO completion:^{
        
    }];
    
}

//-(void)getPedonMeterData{
////    _pedomenter=[[CMPedometer alloc]init];
////
////    [self showHUD:@""];
////
////    if ([CMPedometer isStepCountingAvailable]) {
////        [_pedomenter queryPedometerDataFromDate:_startDate toDate:_endDate withHandler:^(CMPedometerData * _Nullable pedometerData, NSError * _Nullable error) {
////            if (error==nil) {
//                NSInteger step=[pedometerData.numberOfSteps integerValue];
//                
//                NSInteger dis=[self.totallabel.text doubleValue]*1000;
//                RunInfo *model=[RunInfo MR_createEntity];
//                model.time=[NSNumber numberWithDouble:_timecount];
//                
//                
//                model.distance=[NSNumber numberWithInteger:dis];
//                model.speed=[NSNumber numberWithInteger:dis/_timecount/100/60];
//                
//                long index=[[NSDate date] timeIntervalSince1970];
//                
//                model.index=[NSNumber numberWithInteger:index];
//                model.isver=[NSNumber numberWithBool:NO];
//                model.endtime=[NSNumber numberWithLong:[[NSDate date] timeIntervalSince1970]];
//                model.userid=[UserInfoModel shareInstance].ids;
//                model.step=@(step);
//                NSData *array=[NSKeyedArchiver archivedDataWithRootObject:self.locatedline];
//                model.array=array;
//                NSData *tureArray=[NSKeyedArchiver archivedDataWithRootObject:self.tureline];
//                model.tureline=tureArray;
//                [[NSManagedObjectContext MR_defaultContext]MR_saveOnlySelfAndWait];
//                
//                RListViewController *ctrl=[[RListViewController alloc]initWithStyle:UITableViewStylePlain];
//                ctrl.hidesBottomBarWhenPushed=YES;
//                [[AppDelegate shareInstance].startNav pushViewController:ctrl animated:YES];
//                
//                
//                [self dismissViewControllerAnimated:NO completion:^{
//                    
//                }];
//            }
//            
//            [self dissmissHUD];
////        }];
//    }
//}

-(void)uploadCoor2d
{
    //上传坐标
    
    [self showHUD:@"请稍等..."];
    
    double dis=[[self.totallabel.text substringToIndex:self.totallabel.text.length-2] doubleValue]*1000;
    
     NSMutableArray *detail=[NSMutableArray array];
//    for (CLLocation *location in _locatedline) {
//        NSArray *str=@[@(location.coordinate.longitude),@(location.coordinate.latitude)];
//        [detail addObject:str];
//    }    
//    NSString *detailstr=[detail JSONString];
    
    NSString *detailstr=[_tureline JSONString];
    
//    NSDictionary *params=@{@"detail":detailstr,@"userId":[UserInfoModel shareInstance].ids,@"distance":@(dis),@"duration":@(_timecount),@"date":[NSDate date]};
    
    NSDictionary *params=@{@"type":@(0),@"detail":detailstr,@"userId":[UserInfoModel shareInstance].ids,@"distance":@(dis),@"duration":@(_timecount),@"date":[NSDate date],@"step":@(dis)};
    
    NSString *url=[NSString stringWithFormat:@"record/%@",[UserInfoModel shareInstance].ids];
    [Http POSTWithToken:url parameters:params success:^(NSURLSessionDataTask *task, id jsonObject) {
        [self dissmissHUD];
        if([[jsonObject objectForKey:@"success"] boolValue]){
            jsonObject=[jsonObject objectForKey:@"data"];
            NSInteger recordId=[[jsonObject objectForKey:@"recordId"] integerValue];
//            RunInfo *model=[RunInfo MR_createEntity];
//            model.time=[NSNumber numberWithDouble:_timecount];
//            
//            
//            model.distance=[NSNumber numberWithInteger:dis];
//            model.speed=[NSNumber numberWithInteger:dis/_timecount/100/60];
//            
//            model.index=[NSNumber numberWithInteger:recordId];
//            model.isver=[NSNumber numberWithBool:NO];
//            model.endtime=[NSNumber numberWithLong:[[NSDate date] timeIntervalSince1970]];
//            model.userid=[UserInfoModel shareInstance].ids;
//            
//            NSData *array=[NSKeyedArchiver archivedDataWithRootObject:self.locatedline];
//            model.array=array;
//            [[NSManagedObjectContext MR_defaultContext]MR_saveOnlySelfAndWait];
            
            RunInfo *model=[RunInfo MR_createEntity];
            model.time=[NSNumber numberWithDouble:_timecount];
            
            
            model.distance=[NSNumber numberWithInteger:dis];
            model.speed=[NSNumber numberWithInteger:dis/_timecount/100/60];
            
            long index=[[NSDate date] timeIntervalSince1970];
            
            model.index=[NSNumber numberWithInteger:index];
            model.isver=[NSNumber numberWithBool:NO];
            model.endtime=[NSNumber numberWithLong:[[NSDate date] timeIntervalSince1970]];
            model.userid=[UserInfoModel shareInstance].ids;
            model.step=@(dis);
            NSData *array=[NSKeyedArchiver archivedDataWithRootObject:self.locatedline];
            model.array=array;
            NSData *tureArray=[NSKeyedArchiver archivedDataWithRootObject:self.tureline];
            model.tureline=tureArray;
            [[NSManagedObjectContext MR_defaultContext]MR_saveOnlySelfAndWait];
            
            
//            RunDetailViewController *ctrl=[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"rundetail"];
//            ctrl.index=recordId;
//            ctrl.hidesBottomBarWhenPushed=YES;
            RListViewController *ctrl=[[RListViewController alloc]initWithStyle:UITableViewStylePlain];
            ctrl.hidesBottomBarWhenPushed=YES;
//            [self.navigationController pushViewController:ctrl animated:YES];
            [[AppDelegate shareInstance].startNav pushViewController:ctrl animated:YES];

            
            [self dismissViewControllerAnimated:NO completion:^{
                
            }];
            
        }else{
            [self showErrorHUD:@"上传失败,请再试"];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self showErrorHUD:@"上传失败"];
    }];
}

@end
