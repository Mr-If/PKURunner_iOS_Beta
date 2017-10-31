//
//  CalendarViewController.m
//  PKU
//
//  Created by ironfive on 16/8/10.
//  Copyright © 2016年 ironfive. All rights reserved.
//

#import "CalendarViewController.h"

#import "ZZCircleProgress.h"

#import "JTCalendar.h"

#import "HTMLViewController.h"

#import "RListViewController.h"

#import "CalendarViewController_.h"

@interface CalendarViewController ()<JTCalendarDataSource,UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *progressview;

@property (weak, nonatomic) IBOutlet UIView *menu_view;
@property (weak, nonatomic) IBOutlet UILabel *needTimelabel;

@property (weak, nonatomic) IBOutlet UILabel *startTimelabel;
@property (weak, nonatomic) IBOutlet UILabel *endTimelabel;

@property (nonatomic,strong)ZZCircleProgress *pro;

@end

@implementation CalendarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden=YES;
    
    self.menu_view.layer.cornerRadius=5;
    self.menu_view.layer.masksToBounds=YES;
    
    float height=SCREEN_HEIGHT-49-100-50-150;
    
    if (height>=SCREEN_WIDTH-80) {
        height=SCREEN_WIDTH-80;
    }
    
    
    _pro = [[ZZCircleProgress alloc] initWithFrame:CGRectMake(0,0,height,height) pathBackColor:nil pathFillColor:[UIColor colorFromHexString:@"#EC6941"] startAngle:0 strokeWidth:10];
    
    _pro.center=CGPointMake(SCREEN_WIDTH/2.0, height/2.0+10);
    _pro.total=0;
    _pro.finish_score=0;
    _pro.finish=0;
    _pro.showPoint = NO;
    _pro.animationModel = CircleIncreaseSameTime;
    _pro.progress = 0;
    [self.progressview addSubview:_pro];
     [self showHUD:@""];
    [self loadData];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];

    [self loadData];
    
}

- (IBAction)handCenter:(id)sender {
    RListViewController *ctrl=[[RListViewController alloc]initWithStyle:UITableViewStylePlain];
    ctrl.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:ctrl animated:YES];   
}


- (IBAction)handRight:(id)sender {
    CalendarViewController_ *ctrl=[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"calend_"];
    ctrl.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:ctrl animated:YES];
}

- (IBAction)handLeft:(id)sender {
    HTMLViewController *ctrl=[[HTMLViewController alloc]init];
    ctrl.url=@"http://162.105.205.61:10201/help/basic_help.html";
    ctrl.title=@"使用说明";
    ctrl.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:ctrl animated:YES];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

-(void)loadData
{
    
   
    
    NSDateFormatter *matter=[[NSDateFormatter alloc]init];
    [matter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *urlstr=[NSString stringWithFormat:@"record/status/%@",[UserInfoModel shareInstance].ids];
    [Http GETWithToken:urlstr parameters:nil success:^(NSURLSessionDataTask *task, id jsonObject) {
        [self dissmissHUD];
        if ([jsonObject objectForKey:@"data"]) {
            NSDictionary *data=[jsonObject objectForKey:@"data"];
            NSDate *startT =[matter dateFromString:[[data objectForKey:@"beginDate"] substringToIndex:10]];
            NSDate *endT =[matter dateFromString:[[data objectForKey:@"endDate"] substringToIndex:10]];
            
            self.startTimelabel.text=[[data objectForKey:@"beginDate"] substringToIndex:10];
            self.endTimelabel.text=[[data objectForKey:@"endDate"] substringToIndex:10];
            
            long long need=[endT timeIntervalSinceDate:startT];
            NSInteger day=need/(3600*24);
            NSInteger needDay=day>0?day+1:0;
            
            self.needTimelabel.text=[NSString stringWithFormat:@"%ld",needDay];
            
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

@end
