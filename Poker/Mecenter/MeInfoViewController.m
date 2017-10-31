//
//  MeInfoViewController.m
//  PKU
//
//  Created by ironfive on 16/8/30.
//  Copyright © 2016年 ironfive. All rights reserved.
//

#import "MeInfoViewController.h"

#import <HealthKit/HealthKit.h>

#import "MeInfoTableViewCell.h"

@interface MeInfoViewController ()

@property (nonatomic,strong)HKHealthStore  *healstore;

@property (nonatomic,strong)NSMutableArray    *data;

@property (nonatomic,strong)NSTimer           *timer;

@end

@implementation MeInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title=@"个人信息";
    UIImageView *imagerview=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-49)];
    imagerview.image=[UIImage imageNamed:@"bg.jpg"];
    
    self.tableView.backgroundView=imagerview;
    self.tableView.separatorColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.jpg"]];
    
    self.tableView.tableFooterView=[[UIView alloc]init];
    self.data=[NSMutableArray array];
    self.healstore=[[HKHealthStore alloc]init];
    NSSet *healthKitTypesToRead=[NSSet setWithObjects:
                                 [HKObjectType characteristicTypeForIdentifier:HKCharacteristicTypeIdentifierDateOfBirth],
                                 [HKObjectType characteristicTypeForIdentifier:HKCharacteristicTypeIdentifierBloodType],
                                 [HKObjectType characteristicTypeForIdentifier:HKCharacteristicTypeIdentifierBiologicalSex],
                                 [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDistanceWalkingRunning],
                                 [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMassIndex],
                                 [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeight],
                                 [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMass],
                                 [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount],
                                 [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierFlightsClimbed],
                                 nil];
    NSSet *healthKitTypesToWrite=[NSSet setWithObjects:
                                       [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMassIndex],
                                       [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierActiveEnergyBurned],
                                       [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDistanceWalkingRunning],
                                       nil];
    if (![HKHealthStore isHealthDataAvailable]) {
        [self showToast:@"该设备不支持HealthKit应用"];
        return;
    }
    
    [self.healstore requestAuthorizationToShareTypes:healthKitTypesToWrite readTypes:healthKitTypesToRead completion:^(BOOL success, NSError * _Nullable error) {
        if (error==nil) {
            NSLog(@"授权成功");
            [self loadData];
        }else{
            [[TKAlertCenter defaultCenter]postAlertWithMessage:@"请开启获取健康信息权限"];
            [self dissmissHUD];
        }
    }];
    [self showHUD:@"请等待..."];
    _timer=[NSTimer scheduledTimerWithTimeInterval:.5 target:self selector:@selector(reload) userInfo:nil repeats:YES];
}

-(void)reload
{
    NSInteger count=0;
    for (NSMutableArray *array in self.data) {
        count+=array.count;
    }
    
    if (count==8) {
        [_timer invalidate];
        _timer=nil;
        [self dissmissHUD];
        [self.tableView reloadData];
    }
}

-(void)loadData
{
    
    NSError *error;
    //出身日期
    NSDate *date=[self.healstore dateOfBirthWithError:&error];
    
    
    NSDateFormatter *datter=[[NSDateFormatter alloc]init];
    [datter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *bir=@"";
    if (date==nil) {
        bir=@"未设置";
    }else{
        bir=[datter stringFromDate:date];
    }
    NSDictionary *birdic=@{INFO_KEY:@"出生日期",INFO_VALUE:bir};
    //性别
    HKBiologicalSexObject *bioSex=[self.healstore biologicalSexWithError:&error];
    
    NSString *sex=@"";
    switch (bioSex.biologicalSex) {
        case HKBiologicalSexNotSet:
            sex=@"未设置";
            break;
            
        case HKBiologicalSexFemale:
             sex=@"女性";
            break;
            
        case HKBiologicalSexMale:
             sex=@"男性";
            break;
            
        case HKBiologicalSexOther:
             sex=@"其他";
            break;
    }
    NSDictionary *sexdic=@{INFO_KEY:@"性别",INFO_VALUE:sex};
    
    //血型
    
    HKBloodTypeObject *bloodtype=[self.healstore bloodTypeWithError:&error];
  
    NSString *blootypestr=@"";
    switch (bloodtype.bloodType) {
        case HKBloodTypeNotSet:
            blootypestr=@"未设置";
            break;
            
        case HKBloodTypeAPositive:
            blootypestr=@"A+";
            break;

        case HKBloodTypeANegative:
            blootypestr=@"A-";
            break;
        case HKBloodTypeBPositive:
           blootypestr=@"B+";
            break;

        case HKBloodTypeBNegative:
            blootypestr=@"B-";
            break;

        case HKBloodTypeABPositive:
            blootypestr=@"AB+";
            break;

        case HKBloodTypeABNegative:
             blootypestr=@"AB-";
            break;

        case HKBloodTypeOPositive:
             blootypestr=@"O+";
            break;
            
        case HKBloodTypeONegative:
            blootypestr=@"O-";
            break;
    }
    
    NSDictionary *bl=@{INFO_KEY:@"血型",INFO_VALUE:blootypestr};
    
    
    NSMutableArray *info=[NSMutableArray array];
    [info addObject:birdic];
    [info addObject:sexdic];
    [info addObject:bl];
    [self.data insertObject:info atIndex:0];
    
    
    NSMutableArray *runarray=[NSMutableArray array];
    [self.data addObject:runarray];
    
    NSMutableArray *weight_height=[NSMutableArray array];
    [self.data addObject:weight_height];
    
    
    [self loadHeight:[HKSampleType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount] withArray:runarray];
    [self loadHeight:[HKSampleType quantityTypeForIdentifier:HKQuantityTypeIdentifierDistanceWalkingRunning] withArray:runarray];
    [self loadRunSetup:[HKSampleType quantityTypeForIdentifier:HKQuantityTypeIdentifierFlightsClimbed] withArray:runarray];
    
    [self loadHeight:[HKSampleType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeight] withArray:weight_height];
    [self loadHeight:[HKSampleType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMass] withArray:weight_height];
}

-(void)loadRunSetup:(HKSampleType *)type withArray:(NSMutableArray *)array
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSDateComponents *dateCom = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit fromDate:[NSDate date]];
    
    
    
    NSDate *startDate, *endDate;
    
    endDate = [calendar dateFromComponents:dateCom];
    
    
    
    [dateCom setHour:0];
    
    [dateCom setMinute:0];
    
    [dateCom setSecond:0];
    
    
    
    startDate = [calendar dateFromComponents:dateCom];
    // Use the sample type for step count
//    HKSampleType *sampleType = [HKSampleType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
    
    // Create a predicate to set start/end date bounds of the query
    NSPredicate *predicate = [HKQuery predicateForSamplesWithStartDate:startDate endDate:endDate options:HKQueryOptionStrictStartDate];
    
    // Create a sort descriptor for sorting by start date
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:HKSampleSortIdentifierStartDate ascending:NO];
    
    
    HKSampleQuery *sampleQuery = [[HKSampleQuery alloc] initWithSampleType:type
                                                                 predicate:predicate
                                                                     limit:HKObjectQueryNoLimit
                                                           sortDescriptors:@[sortDescriptor]
                                                            resultsHandler:^(HKSampleQuery *query, NSArray *results, NSError *error) {
                                                                
                                                                if(!error && results)
                                                                {
                                                                    double count=0;
                                                                    for (HKQuantitySample *sample in results) {
                                                                        double weight=[sample.quantity doubleValueForUnit:[HKUnit countUnit]];
                                                                        count+=weight;
                                                                    }
                                                                    NSString *weightstr=[NSString stringWithFormat:@"%.0f层",count];
                                                                    NSDictionary *dic=@{INFO_KEY:@"已爬楼层",INFO_VALUE:weightstr};
                                                                    [array addObject:dic];
                                                                }
                                                            }];
    
    // Execute the query
    [self.healstore executeQuery:sampleQuery];
}

-(void)loadHeight:(HKSampleType*)type withArray:(NSMutableArray *)array
{
//    NSDate *past=[NSDate distantPast];
//    NSDate *now=[NSDate date];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSDateComponents *dateCom = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit fromDate:[NSDate date]];
    
    
    
    NSDate *startDate, *endDate;
    
    endDate = [calendar dateFromComponents:dateCom];
    
    
    
    [dateCom setHour:0];
    
    [dateCom setMinute:0];
    
    [dateCom setSecond:0];
    
    
    
    startDate = [calendar dateFromComponents:dateCom];

    
   NSPredicate *mostRecentPredicate=[HKQuery predicateForSamplesWithStartDate:startDate endDate:endDate options:HKQueryOptionNone];
   NSSortDescriptor *sort=[NSSortDescriptor sortDescriptorWithKey:HKSampleSortIdentifierStartDate ascending:NO];
   HKSampleQuery *query=[[HKSampleQuery alloc]initWithSampleType:type predicate:mostRecentPredicate limit:1 sortDescriptors:@[sort] resultsHandler:^(HKSampleQuery * _Nonnull query, NSArray<__kindof HKSample *> * _Nullable results, NSError * _Nullable error) {
       
       if(!error){
           if (type==[HKSampleType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeight]) {
               
               if (results==nil) {
                   NSDictionary *dic=@{INFO_KEY:@"身高",INFO_VALUE:@"未设置"};
                   [array addObject:dic];
               }else{
                   
                   HKQuantitySample *sample=[results lastObject];
                   double weight=[sample.quantity doubleValueForUnit:[HKUnit meterUnit]];
                   NSString *weightstr=[NSString stringWithFormat:@"%.0fcm",weight*100];
                   NSDictionary *dic=@{INFO_KEY:@"身高",INFO_VALUE:weightstr};
                   [array addObject:dic];
               }
               
           }
           
           if (type==[HKSampleType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMass]) {
               if (results==nil) {
                   NSDictionary *dic=@{INFO_KEY:@"体重",INFO_VALUE:@"未设置"};
                   [array addObject:dic];
               }else{
                   HKQuantitySample *sample=[results lastObject];
                   double weight=[sample.quantity doubleValueForUnit:[HKUnit gramUnitWithMetricPrefix:HKMetricPrefixKilo]];
                   NSString *weightstr=[NSString stringWithFormat:@"%.0fkg",weight];
                   NSDictionary *dic=@{INFO_KEY:@"体重",INFO_VALUE:weightstr};
                   [array addObject:dic];
               }
           }
           
           if (type==[HKSampleType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount]) {
               if (results==nil) {
                   NSDictionary *dic=@{INFO_KEY:@"运动步数",INFO_VALUE:@"未设置"};
                   [array addObject:dic];
               }else{
                   HKQuantitySample *sample=[results lastObject];
                   double weight=[sample.quantity doubleValueForUnit:[HKUnit countUnit]];
                   NSString *weightstr=[NSString stringWithFormat:@"%.0f步",weight];
                   NSDictionary *dic=@{INFO_KEY:@"运动步数",INFO_VALUE:weightstr};
                   [array addObject:dic];
               }
           }
           
           if (type==[HKSampleType quantityTypeForIdentifier:HKQuantityTypeIdentifierDistanceWalkingRunning]) {
               if (results==nil) {
                   NSDictionary *dic=@{INFO_KEY:@"运动距离",INFO_VALUE:@"未设置"};
                   [array addObject:dic];
               }else{
                   HKQuantitySample *sample=[results lastObject];
                   double weight=[sample.quantity doubleValueForUnit:[HKUnit meterUnit]];
                   NSString *weightstr=[NSString stringWithFormat:@"%.0fm",weight];
                   NSDictionary *dic=@{INFO_KEY:@"运动距离",INFO_VALUE:weightstr};
                   [array addObject:dic];
               }
           }
       }
    }];
    
    [self.healstore executeQuery:query];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.data.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSMutableArray *array=[self.data objectAtIndex:section];
    return array.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MeInfoTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell==nil) {
        cell=[[[NSBundle mainBundle]loadNibNamed:@"MeInfoTableViewCell" owner:nil options:nil] lastObject];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    cell.model=[[self.data objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return @"本人信息";
    }
    
    if (section==1) {
        return @"健身数据";
    }
    
    if (section==2) {
        return @"身体测量";
    }
    return nil;
}

@end
