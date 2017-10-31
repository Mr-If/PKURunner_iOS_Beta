//
//  CheckViewController.m
//  PKU
//
//  Created by ironfive on 16/8/9.
//  Copyright © 2016年 ironfive. All rights reserved.
//

#import "CheckViewController.h"
#import "SwipeView.h"
#import "LocatationView.h"
#import "ZCTradeView.h"

@interface CheckViewController ()<SwipeViewDataSource,LocatationViewDelegate,ZCTradeViewDelegate,UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet SwipeView *swipeview;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *swipeview_height;

@property (weak, nonatomic) IBOutlet UITextView *textview;
@property (weak, nonatomic) IBOutlet UITextField *hiddentf;

@property (weak, nonatomic) IBOutlet UIButton *carebtu;

@property (nonatomic,strong)NSTimer            *timer;

@property (nonatomic,assign)NSInteger          index;

@property (nonatomic,assign)NSInteger          type;

@property (nonatomic,assign)NSInteger          recordId;

@property (nonatomic,strong)NSDate             *startDate;

@property (nonatomic,strong)NSDate             *endDate;

@property (nonatomic,assign)BOOL               start;

@property (nonatomic,copy)NSString             *password;


@property (nonatomic,strong)ZCTradeView *zctView;

@end

@implementation CheckViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.swipeview_height.constant=SCREEN_WIDTH/2.0;
    self.swipeview.scrollView.bounces=NO;
    self.swipeview.scrollView.scrollEnabled=NO;
    
//    _timer=[NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(MoveBanner:) userInfo:nil repeats:YES];
    
//    
//    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"userid==%@",[UserInfoModel shareInstance].ids];
//    
//    NSArray *array=[RunInfo MR_findAllWithPredicate:predicate];
//    self.runcount=array.count;
    
    
    UIView *inputview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 216)];
    LocatationView *lo=[[[NSBundle mainBundle]loadNibNamed:@"LocatationView" owner:nil options:nil] lastObject];
    lo.frame=inputview.bounds;
    lo.delegate=self;
    [inputview addSubview:lo];
    self.hiddentf.inputView=inputview;
    self.start=NO;
    NSString *text=[NSString stringWithFormat:@"地点:\n\n\n开始时间:\n结束时间:\n"];
    self.textview.text=text;
    self.type=-1;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.swipeview reloadData];
//    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"userid==%@",[UserInfoModel shareInstance].ids];
//    NSArray *array=[RunInfo MR_findAllWithPredicate:predicate];
//    self.runcount=array.count;
    
//    NSDateFormatter *matter=[[NSDateFormatter alloc]init];
//    [matter setDateFormat:@"yyyy-MM-dd HH:mm"];
    
//    if (self.startDate) {
//        NSString *text=[NSString stringWithFormat:@"地点:\nitem%d\n\n开始时间:%@\n结束时间:\n跑步次数:%d次",self.type,[matter stringFromDate:self.startDate],self.runcount];
//        self.textview.text=text;
//    }else if (self.startDate&&self.endDate) {
//        NSString *text=[NSString stringWithFormat:@"地点:\nitem%d\n\n开始时间:%@\n结束时间:%@\n跑步次数:%d次",self.type,[matter stringFromDate:self.startDate],[matter stringFromDate:self.endDate],self.runcount];
//        self.textview.text=text;
//    }else{
//        NSString *text=[NSString stringWithFormat:@"地点:\n\n\n开始时间:\n结束时间:\n跑步次数:%d次",self.runcount];
//        self.textview.text=text;
//    }
}



-(void)MoveBanner:(NSTimer *)timer
{
    _index++;
    NSInteger i=_index%5;
    [self.swipeview scrollToPage:i duration:.25];
}

- (NSInteger)numberOfItemsInSwipeView:(SwipeView *)swipeView
{
    return 5;
}

- (UIView *)swipeView:(SwipeView *)swipeView viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    NSString *name=[NSString stringWithFormat:@"banner%d",index+1];
    UIImage *image=[UIImage imageNamed:name];
    
    if(view==nil){
         UIImageView *imagev=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH/2.0)];
         view=imagev;
    }
    
    UIImageView *imag=(UIImageView *)view;
    imag.image=image;
    return view;
}

-(void)ClickSelect:(NSInteger)index
{
    _index=index;
    _type=index;
    [self.swipeview scrollToPage:index duration:.25];
    NSString *text=[NSString stringWithFormat:@"地点:\nitem%d\n\n开始时间:\n结束时间:\n",self.type+1];
    self.textview.text=text;
    [self.hiddentf resignFirstResponder];
}

-(void)ClickCancel
{
    [self.hiddentf resignFirstResponder];
}

- (IBAction)Clicklocated:(id)sender {
//    UIPickerView *picker=[[UIPickerView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-40, 200)];
//    picker.delegate=self;
//    picker.dataSource=self;
//    picker.center=CGPointMake(SCREEN_WIDTH/2.0, SCREEN_HEIGHT/2.0);
//    picker.backgroundColor=[UIColor lightGrayColor];
//    
//    UIView *view=[[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
//    view.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
//    [[UIApplication sharedApplication].keyWindow addSubview:view];
//    [[UIApplication sharedApplication].keyWindow addSubview:picker];
    [self.hiddentf becomeFirstResponder];
}

- (IBAction)Clickcard:(id)sender {
    
    if (self.type==-1) {
        [self showToast:@"请选择打卡地点"];
        return;
    }
    
        __block CheckViewController *blockSelf = self;
        self.zctView = [ZCTradeView tradeView];
        
        [self.zctView showInView:self.view.window];
        self.zctView.delegate = self;
        self.zctView.finish = ^(NSString *passWord){
            
            NSLog(@"  passWord %@ ",passWord);
            
            [blockSelf.zctView hidenKeyboard];
            
            if(!blockSelf.start){
                [blockSelf showHUD:@"验证中..."];
//                [UtilsHttp getToken:[UserInfoModel shareInstance].phone withPwd:[UserInfoModel shareInstance].pwd withBlock:^(NSString *token) {
                    NSString *url=[NSString stringWithFormat:@"record2/%@",[UserInfoModel shareInstance].ids];
                    NSDictionary *params=@{@"place":@(blockSelf.type),@"token":passWord,@"access_token":[UserInfoModel shareInstance].token};
                    [Http POSTWithToken:url parameters:params success:^(NSURLSessionDataTask *task, id jsonObject) {
                        if ([jsonObject objectForKey:@"access_token"]) {
                            [blockSelf showSuccessHUD:@"验证通过"];
                            [UserInfoModel shareInstance].token=[jsonObject objectForKey:@"access_token"];
                            blockSelf.recordId=[[jsonObject objectForKey:@"recordId"] integerValue];
                            
                            NSDateFormatter *matter=[[NSDateFormatter alloc]init];
                            [matter setDateFormat:@"yyyy-MM-dd HH:mm"];
                            NSDate *starteDate=[NSDate date];
                            blockSelf.startDate=starteDate;
                            NSString *text=[NSString stringWithFormat:@"地点:\nitem%d\n\n开始时间:%@\n结束时间:\n",blockSelf.type+1,[matter stringFromDate:starteDate]];
                            blockSelf.textview.text=text;
                            [blockSelf.carebtu setTitle:@"stop" forState:UIControlStateNormal];
                            blockSelf.start=YES;
                            [blockSelf performSelector:@selector(ShowAlertview) withObject:nil afterDelay:2*3600];
                        }else{
                            [blockSelf showErrorHUD:@"验证失败,请重新验证"];
                        }
                    } failure:^(NSURLSessionDataTask *task, NSError *error) {
                        [blockSelf showErrorHUD:@"验证失败,请重新验证"];
                    }];

//                }withFaile:^(NSString *error) {
//                    [blockSelf showErrorHUD:@"验证失败,请重试"];
//                }];
            }else{
                blockSelf.password=passWord;
                NSDateFormatter *matter=[[NSDateFormatter alloc]init];
                [matter setDateFormat:@"yyyy-MM-dd HH:mm"];
                NSDate *endDate=[NSDate date];
                blockSelf.endDate=endDate;
                NSString *text=[NSString stringWithFormat:@"地点:\nitem%d\n\n开始时间:%@\n结束时间:%@\n",blockSelf.type+1,[matter stringFromDate:blockSelf.startDate],[matter stringFromDate:endDate]];
                blockSelf.textview.text=text;
                
                if (3600*1.5<([endDate timeIntervalSince1970]-[self.startDate timeIntervalSince1970])) {
                    UIAlertView *alertview=[[UIAlertView alloc]initWithTitle:@"提示" message:@"您已超过最大时限" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                    [alertview show];
                }else{
                    [self commit];
                }
            }
        };
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self performSelector:@selector(commit) withObject:nil afterDelay:.25];
}

-(void)ShowAlertview
{
    if(self.start){
        UIAlertView *aertview=[[UIAlertView alloc]initWithTitle:@"提示" message:@"您已经打卡了两小时了" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [aertview show];
    }
}

-(void)commit
{
    [self showHUD:@"上传中..."];
    NSString *url=[NSString stringWithFormat:@"record2/%@/%d",[UserInfoModel shareInstance].ids,self.recordId];
    [Http POSTWithToken:url parameters:@{@"token":self.password} success:^(NSURLSessionDataTask *task, id jsonObject) {
        if([jsonObject objectForKey:@"record"]){
            [self showSuccessHUD:@"打卡成功"];
            [self.carebtu setTitle:@"打卡" forState:UIControlStateNormal];
            self.start=NO;
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(ShowAlertview) object:nil];
        }else{
            [self showErrorHUD:@"打卡失败,请再试"];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self showErrorHUD:@"上传失败"];
    }];
}


@end
