//
//  StartViewController.m
//  PKU
//
//  Created by ironfive on 16/8/9.
//  Copyright © 2016年 ironfive. All rights reserved.
//

#import "StartViewController.h"

#import "RunViewController.h"

#import <AVFoundation/AVFoundation.h>

#import "HTMLViewController.h"
#import "RunInfoModel.h"
@interface StartViewController ()<AMapLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *weicon;
@property (weak, nonatomic) IBOutlet UIView *we_des_view;
@property (weak, nonatomic) IBOutlet UIView *located_des_view;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *weater_view_height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *weater_desc_height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *located_view_height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *total_view_height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *start_btn_height;

@property (weak, nonatomic) IBOutlet UILabel *wear_text;
@property (weak, nonatomic) IBOutlet UIButton *btu_start;

@property (weak, nonatomic) IBOutlet UILabel *weaterlabel;

@property (weak, nonatomic) IBOutlet UILabel *pmlabel;

@property (weak, nonatomic) IBOutlet UILabel *gpslabel;

@property (weak, nonatomic) IBOutlet UILabel *locatedlabel;
@property (weak, nonatomic) IBOutlet UILabel *wearch_label;

@property (weak, nonatomic) IBOutlet UIView *weater_view;
@property (weak, nonatomic) IBOutlet UIView *panel_view;
@property (weak, nonatomic) IBOutlet UILabel *totalTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalDistanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalNumberLabel;

@property (nonatomic,strong)AMapLocationManager *locationmanager;

@property (nonatomic,strong)NSDictionary        *json_obj;

@end

@implementation StartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.weater_view_height.constant=CONTROL_WIDTH(160);
    self.weater_desc_height.constant=CONTROL_WIDTH(70);
    self.located_view_height.constant=CONTROL_WIDTH(50);
    self.total_view_height.constant=CONTROL_WIDTH(100);
    
    self.start_btn_height.constant=CONTROL_WIDTH(100);
    
    self.weater_view.layer.cornerRadius=5;
    self.weater_view.layer.masksToBounds=YES;
    
    self.btu_start.layer.cornerRadius=120;
    self.btu_start.layer.masksToBounds=YES;

    self.panel_view.layer.cornerRadius=5;
    self.panel_view.layer.masksToBounds=YES;
    
    self.btu_start.layer.cornerRadius=5;
    self.btu_start.layer.masksToBounds=YES;
    self.btu_start.layer.borderWidth=2.0;
    self.btu_start.layer.borderColor=[UIColor whiteColor].CGColor;
    

    
   
    [AppDelegate shareInstance].startNav=self.navigationController;
    
    self.weaterlabel.text=@"";
    self.pmlabel.text=@"";
    
    self.gpslabel.text=@"";
    
    self.locatedlabel.text=@"";
    
    self.we_des_view.layer.cornerRadius=5;
    self.we_des_view.layer.masksToBounds=YES;

    self.located_des_view.layer.cornerRadius=3;
    self.located_des_view.layer.masksToBounds=YES;
    
    
    
    self.locationmanager=[[AMapLocationManager alloc]init];
    self.locationmanager.delegate=self;
    [self.locationmanager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    [self.locationmanager setLocationTimeout:6];
    [self.locationmanager setReGeocodeTimeout:3];
    [self loadWeatcherData:@"天津市"];
    
    [self startLocated];
    [self loadD];
}

- (IBAction)ClickRefsh:(id)sender {
    [self loadWeatcherData:@""];
    [self startLocated];
    [self loadD];
}

//- (IBAction)ClickTip:(id)sender {
//    
//    if (!_json_obj) {
//        [WeatcherHttp GET:@"http://162.105.205.61:10201/weather/CN101010100/all" parameters:nil success:^(NSURLSessionDataTask *task, id jsonObject) {
//            _json_obj=jsonObject;
//            [self showPop];
//        } failure:^(NSURLSessionDataTask *task, NSError *error) {
//            
//        }];
//    }else{
//        
//        [self showPop];
//    }
//}

- (IBAction)ClickShowTip:(id)sender {
    [self showToast:@"目前只能获取本地天气"];
}

-(void)showPop
{
    NSDictionary *s=[_json_obj objectForKey:@"suggestion"];
   
    NSString *air=[NSString stringWithFormat:@"空气条件:%@。%@", [[s objectForKey:@"air"] objectForKey:@"brf"], [[s objectForKey:@"air"] objectForKey:@"txt"]];
//    NSString *comf=[NSString stringWithFormat:@"生活指数%@\n%@", [[s objectForKey:@"comf"] objectForKey:@"brf"], [[s objectForKey:@"comf"] objectForKey:@"txt"]];
      NSString *sport=[NSString stringWithFormat:@"运动提示:%@。%@", [[s objectForKey:@"sport"] objectForKey:@"brf"], [[s objectForKey:@"sport"] objectForKey:@"txt"]];
    
    NSString  *message=[NSString stringWithFormat:@"%@\n%@",air,sport];
    
    self.wearch_label.text=message;
    self.wearch_label.font=[UIFont systemFontOfSize:15];
    self.wearch_label.adjustsFontSizeToFitWidth=YES;
//    self.wearch_label.minimumScaleFactor=0.5;
//    [self.wearch_label sizeToFit ];//:CGSizeMake(SCREEN_WIDTH-40, 40)];
    
//    UIAlertController *ctrl=[UIAlertController alertControllerWithTitle:@"提醒" message:message preferredStyle:UIAlertControllerStyleAlert];
//    
//    UIAlertAction *cancel=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//        
//    }];
//    [ctrl addAction:cancel];
//    [self presentViewController:ctrl animated:YES completion:NULL];
}

- (IBAction)ClickHelp:(id)sender {
    HTMLViewController *ctrl=[[HTMLViewController alloc]init];
    ctrl.title=@"帮助文档";
    ctrl.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:ctrl animated:YES];
}


-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
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
            
            
            self.totalNumberLabel.text=[NSString stringWithFormat:@"%d",total.count];
            
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
            
            self.totalDistanceLabel.text=[NSString stringWithFormat:@"%.1f",distance/1000];
            self.totalDistanceLabel.adjustsFontSizeToFitWidth=YES;
            self.totalTimeLabel.text=[NSString stringWithFormat:@"%.1f",time/3600];
        }
        
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
    }];

}

-(void)loadWeatcherData:(NSString *)city
{
    [WeatcherHttp GET:@"http://162.105.205.61:10201/weather/all" parameters:nil success:^(NSURLSessionDataTask *task, id jsonObject) {
        [self dissmissHUD];
        
        if ([jsonObject objectForKey:@"aqi"]) {
            self.weaterlabel.text=[NSString stringWithFormat:@"%@℃",[[jsonObject objectForKey:@"now"] objectForKey:@"fl"]];
            
            NSString *pm_text=[NSString stringWithFormat:@"PM2.5:%@",[[[jsonObject objectForKey:@"aqi"] objectForKey:@"city"] objectForKey:@"pm25"]];
            NSMutableAttributedString *attr=[[NSMutableAttributedString alloc]initWithString:pm_text];
            [attr addAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:17.0],NSForegroundColorAttributeName:[UIColor whiteColor]} range:NSMakeRange(0, 6)];

            [attr addAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:17.0],NSForegroundColorAttributeName:[UIColor colorFromHexString:@"#FF9F2C"]} range:NSMakeRange(6, pm_text.length-6)];
            self.pmlabel.attributedText=attr;
            
            self.wear_text.text=[[[jsonObject objectForKey:@"now"] objectForKey:@"cond"] objectForKey:@"txt"];
            _json_obj=jsonObject;
            
            NSInteger we_code=[[[[jsonObject objectForKey:@"now"] objectForKey:@"cond"] objectForKey:@"code"] integerValue];
            
            NSString *weIconName=@"";
            if (we_code==100) {
                weIconName=@"晴";
            }
            
            if (we_code>=101&&we_code<=103){
                weIconName=@"多云";
            }
         
            if (we_code==104){
                weIconName=@"阴";
            }
            
            if (we_code>=205&&we_code<=213){
                weIconName=@"大风";
            }
           
            if (we_code>=300&&we_code<=304){
                weIconName=@"雷阵雨";
            }
            
            if (we_code==305||we_code==306||we_code==309){
                weIconName=@"小到中雨";
            }
          
            if (we_code==307||(we_code>=310&&we_code<=313)){
                weIconName=@"大到暴雨";
            }
          
            if (we_code==400||we_code==401){
                weIconName=@"小到中雪";
            }
            
            if (we_code==402||we_code==403){
                weIconName=@"大到暴雪";
            }
            
            if (we_code>=404&&we_code<=406){
                weIconName=@"雨夹雪";
            }
           
            if (we_code>=501&&we_code<=502){
                weIconName=@"雾霾";
            }
          
            if (we_code==503||we_code==504||we_code==507||we_code==508){
                weIconName=@"沙尘暴";
            }
            
            if (we_code==100) {
            
                NSDate *date=[NSDate date];
                NSCalendar *cal = [NSCalendar currentCalendar];
                NSDateComponents *components = [cal components:NSCalendarUnitHour fromDate:date];
                if([components hour]>=19){
                    weIconName=@"晴-夜晚";
                }
            }
            
            self.weicon.image=[UIImage imageNamed:weIconName];
            
            [self showPop];
        }
        _json_obj=jsonObject;
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
          [self dissmissHUD];
    }];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

-(void)getGPS:(CLLocation *)location
{
    double horaccuracy=location.horizontalAccuracy;
    if (horaccuracy>100) {
        horaccuracy=100;
    }
    double value=(1-horaccuracy/100.0)*100;
   NSString *gp =[NSString stringWithFormat:@"GPS:%.0f%%",value];
    
    NSMutableAttributedString *attr=[[NSMutableAttributedString alloc]initWithString:gp];
    [attr addAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:17.0],NSForegroundColorAttributeName:[UIColor whiteColor]} range:NSMakeRange(0, 4)];
    
    [attr addAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:17.0],NSForegroundColorAttributeName:[UIColor colorFromHexString:@"#FF9F2C"]} range:NSMakeRange(4, gp.length-4)];
     self.gpslabel.attributedText=attr;

}

-(void)startLocated
{
    [self showHUD:@"请等待..."];
    
    [self.locationmanager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        
        if (!error) {
            self.locatedlabel.adjustsFontSizeToFitWidth=YES;
            self.locatedlabel.text=regeocode.formattedAddress;
            [self getGPS:location];
            if(regeocode.city.length<=0){
                [self  loadWeatcherData:regeocode.province];
            }else{
                [self loadWeatcherData:regeocode.city];
            }
        }else{
             self.locatedlabel.text=@"获取地理位置信息失败";
            [self dissmissHUD];
        }
    }];
}

- (IBAction)ClickStart:(id)sender {
    
    RunViewController *ctrl= [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"runviewctrl"];

    [self presentViewController:ctrl animated:NO completion:NULL];
   
}




@end
