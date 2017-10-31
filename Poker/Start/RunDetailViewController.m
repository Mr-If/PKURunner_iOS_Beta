//
//  RunDetailViewController.m
//  PKU
//
//  Created by ironfive on 16/8/10.
//  Copyright © 2016年 ironfive. All rights reserved.
//

#import "RunDetailViewController.h"
#import "MyPointAnnotation.h"
#import "HTMLViewController.h"

#import "MAMutablePolyline.h"
#import "MAMutablePolylineRenderer.h"

@interface RunDetailViewController ()<MAMapViewDelegate,UIAlertViewDelegate,ImagePopViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *tipBtn;
@property (weak, nonatomic) IBOutlet UIButton *locatedBtn;
@property (weak, nonatomic) IBOutlet UIButton *peopleBtn;
@property (weak, nonatomic) IBOutlet UILabel *namelabel;

@property (weak, nonatomic) IBOutlet UIView *infoview;
@property (weak, nonatomic) IBOutlet UIButton *backbtn;
@property (weak, nonatomic) IBOutlet MAMapView *mapview;
@property (weak, nonatomic) IBOutlet UILabel *date_label;

@property (weak, nonatomic) IBOutlet UILabel *totallabel;

@property (weak, nonatomic) IBOutlet UILabel *timelabel;

@property (weak, nonatomic) IBOutlet UILabel *speedlabel;

@property (weak, nonatomic) IBOutlet UIButton *ver_btu;
@property (weak, nonatomic) IBOutlet UIImageView *head;

@property (weak, nonatomic) IBOutlet UILabel *steplabel;
@property (nonatomic,strong)RunInfo           *info;
@property (weak, nonatomic) IBOutlet UILabel *des;

@property (nonatomic,strong)NSMutableArray    *speedColors;

@property (nonatomic,strong)MAMutablePolyline       *polyline;

@property (nonatomic, strong) MAMutablePolylineRenderer *mutableView;

@property (nonatomic,assign)BOOL              isver;

@property (nonatomic,strong)id  jsonModel;

@end

@implementation RunDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationController.navigationBarHidden=YES;
    self.title=@"详情";
    if ([[UserInfoModel shareInstance].sex isEqualToString:@"男"]) {
        [self.peopleBtn setImage:[UIImage imageNamed:@"男照片"] forState:UIControlStateNormal];
        
    }else{
        [self.peopleBtn setImage:[UIImage imageNamed:@"女照片"] forState:UIControlStateNormal];
    }
    
    
    self.infoview.layer.cornerRadius=5;
    self.infoview.layer.masksToBounds=YES;
    
    
    self.head.layer.cornerRadius=40;
    self.head.layer.masksToBounds=YES;
    self.namelabel.text=[UserInfoModel shareInstance].name;
    
   self.head.image = [UIImage imageNamed:@"banner1"];
    self.backbtn.layer.cornerRadius=20;
    self.backbtn.layer.masksToBounds=YES;
   
    
    self.peopleBtn.layer.cornerRadius=20;
    self.peopleBtn.layer.masksToBounds=YES;
    
    self.locatedBtn.layer.cornerRadius=20;
    self.locatedBtn.layer.masksToBounds=YES;
    
    self.tipBtn.layer.cornerRadius=20;
    self.tipBtn.layer.masksToBounds=YES;
    
    _mapview.logoCenter=CGPointMake(SCREEN_WIDTH-_mapview.logoSize.width/2.0, SCREEN_HEIGHT-80-64);
    self.mapview.delegate=self;
    _mapview.showsCompass=NO;
    _mapview.showsScale=NO;
    _mapview.zoomLevel=16.0;
    _mapview.rotateEnabled=NO;
    _mapview.rotateCameraEnabled=NO;
    self.mapview.showsUserLocation=NO;
    self.isver=NO;
    
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"index==%d AND userid==%@",_index,[UserInfoModel shareInstance].ids];
    _info=[[RunInfo MR_findAllWithPredicate:predicate inContext:[NSManagedObjectContext MR_defaultContext]] lastObject];
    
    if (_info) {
        NSArray *array=[NSKeyedUnarchiver unarchiveObjectWithData:_info.array];
//        _speedColors=[NSMutableArray array];
        self.polyline=[[MAMutablePolyline alloc]initWithPoints:@[]];
        
//        CLLocationCoordinate2D commonPolylineCoords[array.count];
//        NSMutableArray       *index=[NSMutableArray array];
        for (int i=0; i<array.count; i++) {
            CLLocation *location=[array objectAtIndex:i];
//            commonPolylineCoords[i].latitude = location.coordinate.latitude;
//            commonPolylineCoords[i].longitude = location.coordinate.longitude;
            double speed=location.speed;
            UIColor *speedColor=[self getColorForSpeed:speed];
//            [_speedColors addObject:speedColor];
//            [index addObject:@(i)];
            [self.polyline appendPoint:MAMapPointForCoordinate(location.coordinate)];
            [self.polyline appendColor:speedColor];
        }
        
        
        CLLocation *cen=[array objectAtIndex:array.count/2.0];
        _mapview.centerCoordinate=cen.coordinate;
        
//        _polyline = [MAMultiPolyline polylineWithCoordinates:commonPolylineCoords count:array.count drawStyleIndexes:index];
        
        
        
        [_mapview addOverlay:_polyline];
        
        CLLocation *startlocatation=[array firstObject];
        MyPointAnnotation *annotation=[[MyPointAnnotation alloc]init];
        annotation.coordinate=startlocatation.coordinate;
        annotation.isstart=YES;
        [_mapview addAnnotation:annotation];
        
        CLLocation *endlocatation=[array lastObject];
        MyPointAnnotation *annotation1=[[MyPointAnnotation alloc]init];
        annotation1.coordinate=endlocatation.coordinate;
        annotation1.isstart=NO;
        [_mapview addAnnotation:annotation1];
        
        NSDateFormatter *matter=[[NSDateFormatter alloc]init];
        [matter setDateFormat:@"yyyy-MM-dd"];
        NSDate *date=[NSDate dateWithTimeIntervalSince1970:[_info.endtime longLongValue]];
        self.date_label.text=[UtilsHttp getCurrentDate:date];
        
        self.steplabel.text=[_info.step description];
        self.totallabel.text=[NSString stringWithFormat:@"%.2f",[_info.distance doubleValue]/[_info.time doubleValue]*60/1000];
        

        
        NSString *startTime=[NSString stringWithFormat:@"%02d:%02d:%02d",[_info.time integerValue]/60/60%24,[_info.time integerValue]/60%60,[_info.time integerValue]%60];
        self.timelabel.text=startTime;
        
        double speed=[_info.distance doubleValue]/[_info.time doubleValue];
        NSInteger speed_time=1000/speed;
        
//        self.speedlabel.text=[NSString stringWithFormat:@"%.2f",[_info.distance doubleValue]/1000];
        self.speedlabel.text=[NSString stringWithFormat:@"%d'%d''",speed_time/60,speed_time%60];
        
//        self.isver=[_info.isver boolValue];
//        if ([_info.isver boolValue]) {
//            [self.ver_btu setTitle:@"验证通过" forState:UIControlStateNormal];
//            [self.ver_btu setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//            self.ver_btu.backgroundColor=[UIColor colorFromHexString:@"#ff5d47"];
//            self.ver_btu.layer.cornerRadius=15;
//            self.ver_btu.enabled=NO;
//        }else{
            [self.ver_btu setTitle:@"尚未上传" forState:UIControlStateNormal];
            [self.ver_btu setTitleColor:[UIColor colorFromHexString:@"#ff5d47"] forState:UIControlStateNormal];
            self.ver_btu.backgroundColor=[UIColor whiteColor];
            self.ver_btu.layer.borderColor=[UIColor colorFromHexString:@"#ff5d47"].CGColor;
            self.ver_btu.layer.borderWidth=2.0;
            self.ver_btu.layer.cornerRadius=15;
            self.ver_btu.enabled=NO;

//        }
        
        if (_info.photoFilename.length<=0) {
            self.peopleBtn.enabled=NO;
            [self.peopleBtn setImage:[UIImage imageNamed:@"无照片"] forState:UIControlStateNormal];
        }
        _jsonModel=_info;
    }else{
        [self loadData];
    }
    
    //构造多边形数据对象
    CLLocationCoordinate2D coordinates[4];
    coordinates[0].latitude = -90;
    coordinates[0].longitude = -180;
    
    coordinates[1].latitude = 90;
    coordinates[1].longitude = -180;
    
    coordinates[2].latitude = 90;
    coordinates[2].longitude = 180;
    
    coordinates[3].latitude = -90;
    coordinates[3].longitude = 180;
    
    MAPolygon *polygon = [MAPolygon polygonWithCoordinates:coordinates count:4];
    
    //在地图上添加多边形对象
    [_mapview addOverlay: polygon];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}



- (IBAction)ClickTip:(id)sender {
    
    HTMLViewController *ctrl=[[HTMLViewController alloc]init];
    ctrl.title=@"帮助说明";
    ctrl.url=@"http://162.105.205.61:10201/help/help_running.html";
    [self.navigationController pushViewController:ctrl animated:YES];
}

- (IBAction)ClickLoBtn:(id)sender {
    if (_info) {
        NSArray *array=[NSKeyedUnarchiver unarchiveObjectWithData:_info.array];
        CLLocation *location=[array firstObject];
        CLLocationCoordinate2D coor2d=CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude);
        
        _mapview.centerCoordinate=coor2d;
        _mapview.zoomLevel=16;
    }else{
        
        NSArray *lat_array=[[_jsonModel objectForKey:@"detail"] firstObject];
        double lat=[[lat_array objectAtIndex:1] doubleValue];
        double lon=[[lat_array objectAtIndex:0] doubleValue];
        
        CLLocationCoordinate2D coor2d=CLLocationCoordinate2DMake(lat, lon);
        
        _mapview.centerCoordinate=coor2d;
        _mapview.zoomLevel=16;    
    }
    
}

- (IBAction)ClickPeople:(id)sender {
    
    [ImagePopView show:_jsonModel withShow:YES withDelegate:self];
}

-(void)restartImage:(id)model
{
//    _selectModel=model;
    UIImagePickerController *ctrl=[[UIImagePickerController alloc]init];
    ctrl.sourceType=UIImagePickerControllerSourceTypePhotoLibrary|UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    ctrl.delegate=self;
    [self presentViewController:ctrl animated:YES completion:NULL];
}


-(NSData *)getZomeImageData:(UIImage *)image
{
    NSData * data = UIImageJPEGRepresentation(image, 1.0);
    CGFloat dataKBytes = data.length/1000.0;
    CGFloat maxQuality = 0.9f;
    CGFloat lastData = dataKBytes;
    while (dataKBytes > 500 && maxQuality > 0.01f) {
        maxQuality = maxQuality - 0.01f;
        data = UIImageJPEGRepresentation(image, maxQuality);
        dataKBytes = data.length / 1000.0;
        if (lastData == dataKBytes) {
            break;
        }else{
            lastData = dataKBytes;
        }
    }
    return data;
}


-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
    UIImage *image=[info objectForKey:@"UIImagePickerControllerOriginalImage"];
    if ([_jsonModel isKindOfClass:[RunInfo class]]) {
        RunInfo *m=(RunInfo *)_jsonModel;
        
        if(m.imageData){
            m.restart=@(1);
        }else{
            m.restart=@(0);
        }
        
        m.imageData=[self getZomeImageData:image];
        m.photoFilename=@"123.png";
        
        if ([m.restart integerValue]==1) {
            [self showToast:@"已重新拍摄"];
        }
        
        [[NSManagedObjectContext MR_defaultContext]MR_saveOnlySelfAndWait];
    }else if([_jsonModel isKindOfClass:[NSDictionary class]]){
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self saveImageData:image];
        });
    }else if([_jsonModel isKindOfClass:[LineInfo class]]){
        LineInfo *m=(LineInfo *)_jsonModel;
        
        if(m.imageData){
            m.restart=@(1);
        }else{
            m.restart=@(0);
        }
        
        m.imageData=[self getZomeImageData:image];
        if ([m.restart integerValue]==1) {
            [self showToast:@"已重新拍摄"];
        }
        
        [[NSManagedObjectContext MR_defaultContext]MR_saveOnlySelfAndWait];
    }
    
}

-(void)saveImageData:(UIImage *)image
{
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"index==%d && userid==%@", [[_jsonModel objectForKey:@"recordId"] integerValue],[UserInfoModel shareInstance].ids];
    
    LineInfo *info=[[LineInfo MR_findAllWithPredicate:predicate] lastObject];
    
    if (info==nil) {
        info=[LineInfo MR_createEntity];
        info.restart=@(0);
    }else{
        info.restart=@(1);
    }
    
    if ([info.restart integerValue]==1) {
        [self showToast:@"已重新拍摄"];
    }
    
    info.userid=[UserInfoModel shareInstance].ids;
    info.index=@([[_jsonModel objectForKey:@"recordId"] integerValue]);
    info.imageData=[self getZomeImageData:image];
    [[NSManagedObjectContext MR_defaultContext]MR_saveOnlySelfAndWait];
}

- (IBAction)ClickBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}



-(BOOL)navigationShouldPopOnBackButton
{
//    if (!self.isver) {
//        UIAlertView *alertview=[[UIAlertView alloc]initWithTitle:@"提示" message:@"只有验证过后的跑步记录才可以被保存,真的要离开吗?" delegate:self cancelButtonTitle:@"删除" otherButtonTitles:@"验证", nil];
//        [alertview show];
//        return NO;
//    }
    return YES;
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {
        [self performSelector:@selector(commit) withObject:nil afterDelay:.5];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)loadData
{
    [self showHUD:@"请等待..."];
 NSString *url=[NSString stringWithFormat:@"record/%@/%d",[UserInfoModel shareInstance].ids,_index];
 [Http GETWithToken:url parameters:nil success:^(NSURLSessionDataTask *task, id jsonObject) {
     if ([jsonObject objectForKey:@"success"]) {
         NSDictionary *dic=[jsonObject objectForKey:@"data"];
         _jsonModel=dic;
         
         if ([[dic objectForKey:@"photoPath"] description].length<=0) {
             self.peopleBtn.enabled=NO;
             [self.peopleBtn setImage:[UIImage imageNamed:@"无照片"] forState:UIControlStateNormal];
         }
         
         double distance=[[dic objectForKey:@"distance"] doubleValue];
         
         self.speedlabel.text=[NSString stringWithFormat:@"%.2f",distance/1000];
        
         NSDateFormatter *matter=[[NSDateFormatter alloc]init];
         [matter setDateFormat:@"yyyy-MM-dd"];
         NSDate *date=[matter dateFromString:[[[[dic objectForKey:@"date"] description] substringToIndex:10] description]];
         self.date_label.text=[UtilsHttp getCurrentDate:date];
         NSInteger time=[[dic objectForKey:@"duration"] integerValue];
         
         NSString *startTime=[NSString stringWithFormat:@"%02d:%02d:%02d",time/60/60%24,time/60%60,time%60];
         self.timelabel.text=startTime;
         
         double speed=distance/time;
         NSInteger speed_time=1000/speed;
         
//         self.totallabel.text=[NSString stringWithFormat:@"%.2f",distance/time*60/1000];
//         NSInteger speed_time=1000/speed;
         self.totallabel.text=[NSString stringWithFormat:@"%d'%d''",speed_time/60,speed_time%60];
         
         BOOL isver=[[dic objectForKey:@"verified"] boolValue];
         self.isver=isver;
         if (isver) {
             [self.ver_btu setTitle:@"有效记录" forState:UIControlStateNormal];
             [self.ver_btu setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
             self.ver_btu.backgroundColor=[UIColor colorFromHexString:@"#ff5d47"];
             self.ver_btu.layer.cornerRadius=15;
             self.ver_btu.enabled=NO;
         }else{
             [self.ver_btu setTitle:@"休闲记录" forState:UIControlStateNormal];
             [self.ver_btu setTitleColor:[UIColor colorFromHexString:@"#ff5d47"] forState:UIControlStateNormal];
             self.ver_btu.backgroundColor=[UIColor whiteColor];
             self.ver_btu.layer.cornerRadius=15;
             self.ver_btu.layer.borderColor=[UIColor colorFromHexString:@"#ff5d47"].CGColor;
             self.ver_btu.layer.borderWidth=2.0;
             self.ver_btu.enabled=NO;
             
         }
         
         
         self.steplabel.text=[[dic objectForKey:@"step"] description];
         
         NSArray *lat_array=[dic objectForKey:@"detail"];
         
         
          self.polyline=[[MAMutablePolyline alloc]initWithPoints:@[]];
         for (int i=0; i<lat_array.count; i++) {
             
             NSArray *ll=[lat_array objectAtIndex:i];
             
             double lat=[[ll objectAtIndex:1] doubleValue];
             double lon=[[ll objectAtIndex:0] doubleValue];
             
             
             if (ll.count==3) {
                 MyPointAnnotation *annotation=[[MyPointAnnotation alloc]init];
                 annotation.coordinate=CLLocationCoordinate2DMake(180,180);
                 annotation.isstart=YES;
                 [_mapview addAnnotation:annotation];
             }
             
             if (i==0) {
                 MyPointAnnotation *annotation=[[MyPointAnnotation alloc]init];
                 annotation.coordinate=CLLocationCoordinate2DMake(lat, lon);
                 annotation.isstart=YES;
                 [_mapview addAnnotation:annotation];
             }
             
             if (i==lat_array.count-1) {
                 MyPointAnnotation *annotation1=[[MyPointAnnotation alloc]init];
                 annotation1.coordinate=CLLocationCoordinate2DMake(lat, lon);
                 annotation1.isstart=NO;
                 [_mapview addAnnotation:annotation1];
             }
             
              [self.polyline appendPoint:MAMapPointForCoordinate(CLLocationCoordinate2DMake(lat, lon))];
             
             double speed=distance/time;
             UIColor *speedColor=[self getColorForSpeed:speed];
             
             [self.polyline appendColor:speedColor];
         }
         
         [_mapview addOverlay:_polyline];
         const CGFloat screenEdgeInset = 40;
         UIEdgeInsets inset = UIEdgeInsetsMake(screenEdgeInset, screenEdgeInset, screenEdgeInset, screenEdgeInset);
         [_mapview setVisibleMapRect:_polyline.boundingMapRect edgePadding:inset animated:YES];
     }
     
     [self dissmissHUD];
 } failure:^(NSURLSessionDataTask *task, NSError *error) {
     [self showErrorHUD:@"加载失败"];
 }];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (_info) {
        const CGFloat screenEdgeInset = 40;
        UIEdgeInsets inset = UIEdgeInsetsMake(screenEdgeInset, screenEdgeInset, screenEdgeInset, screenEdgeInset);
        [_mapview setVisibleMapRect:_polyline.boundingMapRect edgePadding:inset animated:YES];
    }
}

- (UIColor *)getColorForSpeed:(float)speed
{
    const float lowSpeedTh = 2.f;
    const float highSpeedTh = 3.5f;
    const CGFloat warmHue = 0.2f; //偏暖色
    const CGFloat coldHue = 0.4f; //偏冷色
    
    float hue = coldHue - (speed - lowSpeedTh)*(coldHue - warmHue)/(highSpeedTh - lowSpeedTh);
    return [UIColor colorWithHue:hue saturation:1.f brightness:1.f alpha:1.f];
}


- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id <MAOverlay>)overlay
{
    
    if ([overlay isKindOfClass:[MAMutablePolyline class]])
    {
        MAMutablePolylineRenderer *polylineRenderer = [[MAMutablePolylineRenderer alloc] initWithMutablePolyline:overlay withDetail:YES];
        polylineRenderer.lineWidth    = 8.f;
        polylineRenderer.lineJoinType = kMALineJoinRound;
        polylineRenderer.lineCapType  = kMALineCapRound;
        return polylineRenderer;
    }
    
    if ([overlay isKindOfClass:[MAPolygon class]])
    {
        MAPolygonRenderer *polygonRenderer = [[MAPolygonRenderer alloc] initWithPolygon:overlay];
        polygonRenderer.lineWidth    = 5.f;
        polygonRenderer.strokeColor  = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        polygonRenderer.fillColor    = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        polygonRenderer.lineJoinType = kMALineJoinMiter;
        
        return polygonRenderer;
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

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    self.mapview.delegate=nil;
}

- (IBAction)ClickVerBtu:(id)sender {
    [self commit];
}

-(void)commit
{
    [self showHUD:@"验证中..."];
    NSString *url=[NSString stringWithFormat:@"record/%@/%d/verify",[UserInfoModel shareInstance].ids,_index];
    
    NSMutableArray *detail=[NSMutableArray array];
    NSArray *array=[NSKeyedUnarchiver unarchiveObjectWithData:_info.array];
    for (CLLocation *location in array) {
        //        CLLocation *location=[dic objectForKey:@"location"];
        NSString *str=[NSString stringWithFormat:@"[%f,%f]",location.coordinate.latitude,location.coordinate.longitude];
        //        [detail addObject:@[@(location.coordinate.latitude),@(location.coordinate.longitude)]];
        [detail addObject:str];
    }
    
    NSString *detailstr=[detail JSONString];
    
    NSDictionary *params=@{@"detail":detailstr};
    [Http POSTWithToken:url parameters:params success:^(NSURLSessionDataTask *task, id jsonObject) {
        
        if([[jsonObject objectForKey:@"success"] integerValue]==1){
            [self showSuccessHUD:@"验证通过"];
            _info.isver=[NSNumber numberWithBool:YES];
            [[NSManagedObjectContext MR_defaultContext]MR_saveOnlySelfAndWait];
            
            [self.ver_btu setTitle:@"已验证" forState:UIControlStateNormal];
            self.ver_btu.enabled=NO;
            self.isver=YES;
        }else{
            [self showErrorHUD:@"验证失败"];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self showErrorHUD:@"验证失败"];
    }];
}


@end
