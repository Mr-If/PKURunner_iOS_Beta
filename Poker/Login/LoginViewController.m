//
//  LoginViewController.m
//  Runing
//
//  Created by ironfive on 16/8/9.
//  Copyright © 2016年 ironfive. All rights reserved.
//

#import "LoginViewController.h"

#import "SVProgressHUD.h"

#import "MainTabBarViewController.h"

#import "PKUiAAA_iOS/PKUiAAA_Authen.h"

@interface LoginViewController ()<PKUOpenAPIDelegate>
@property (weak, nonatomic) IBOutlet UIButton *login_btu;
@property (weak, nonatomic) IBOutlet UITextField *amount;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UIView *contentview;


@property (weak, nonatomic) IBOutlet UIView *line;


@property (weak, nonatomic) IBOutlet UIImageView *logo;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *margin_top;
@property (weak, nonatomic) IBOutlet UIView *margin_view;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.login_btu.layer.cornerRadius=5;
    self.login_btu.layer.masksToBounds=YES;
    
    self.contentview.layer.cornerRadius=5;
    self.contentview.layer.masksToBounds=YES;
    self.contentview.layer.borderColor=[UIColor colorFromHexString:@"#f9f9f9" withAl:0.6].CGColor;
    self.contentview.layer.borderWidth=1.0;
    self.line.backgroundColor=[UIColor whiteColor];
    
    self.margin_top.constant=(SCREEN_HEIGHT-253)/2.0;
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hidden)];
    [self.view addGestureRecognizer:tap];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(KeyBoardShow) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(KeyBoardHidden) name:UIKeyboardWillHideNotification object:nil];
}

-(void)hidden
{
    [self.view endEditing:NO];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [[IQKeyboardManager sharedManager] setEnable:NO];
    [IQKeyboardManager sharedManager].enableAutoToolbar=NO;
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [[IQKeyboardManager sharedManager]setEnable:YES];
    [IQKeyboardManager sharedManager].enableAutoToolbar=YES;
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

-(void)KeyBoardShow
{
    [self.margin_view layoutIfNeeded];
    [UIView animateWithDuration:.25 animations:^{
        float top=SCREEN_HEIGHT-253-216;
        self.margin_top.constant=top;
        [self.margin_view layoutIfNeeded];
    }];
}

-(void)KeyBoardHidden
{
    [self.margin_view layoutIfNeeded];
    [UIView animateWithDuration:.25 animations:^{
        self.margin_top.constant=(SCREEN_HEIGHT-253)/2.0;
        [self.margin_view layoutIfNeeded];
    }];
}

- (IBAction)ClickLoginAction:(UIButton *)sender {
    [self.view endEditing:NO];
//    
//    [self.amount resignFirstResponder];
//    [self.password resignFirstResponder];
//   
//    if (self.amount.text.length<=0||[self.amount.text isEqualToString:@""]) {
//        [self showToast:@"请输入账号"];
//        return;
//    }
//    
//    if (self.password.text.length<=0||[self.password.text isEqualToString:@""]) {
//        [self showToast:@"请输入密码"];
//        return;
//    }
//    
//     [self showHUD:@"登录中..."];
//    
//    [UtilsHttp getToken:self.amount.text withPwd:self.password.text withBlock:^(NSString *token) {
//        [self loginVer];
//    }withFaile:^(NSString *error) {
//        [self showErrorHUD:@"登录失败,请重试"];
//    }];
    
    PKUOpenAPI *testController = [[PKUOpenAPI alloc]init];
    
    testController.delegate = self;
    
    testController.appID = @"PKU_Runner";
    
    [self presentViewController:testController animated:YES completion:nil];
}

-(void)authenticateSuccess: (NSString*) uid withToken: (NSString*)token {
    
    
    [self showHUD:@"登录中..."];
    
    [UserInfoModel shareInstance].token=token;
    [UserInfoModel shareInstance].ids=uid;
//    [UserInfoModel shareInstance].pwd=[MD5Encode md5HexDigest:pwd];

    [self loginVer];
    [UIView setAnimationsEnabled:YES];
}

-(void)authenticateCancel{
    [self showErrorHUD:@"取消登陆"];
}

-(void)loginVer
{
    //@"id":[UserInfoModel shareInstance].ids,
    NSDictionary *params=@{@"access_token":[UserInfoModel shareInstance].token};
    [Http POST:@"user" parameters:params success:^(NSURLSessionDataTask *task, id jsonObject) {
        
        if([[jsonObject objectForKey:@"success"] boolValue]){
            [self dissmissHUD];
            
            [[UserInfoModel shareInstance] setDic:jsonObject];
//            [jsonObject setObject:[UserInfoModel shareInstance].pwd forKey:@"pwd"];
           [jsonObject setObject:[UserInfoModel shareInstance].token forKey:@"token"];
            [[NSUserDefaults standardUserDefaults]setObject:jsonObject forKey:@"user"];
            [[NSUserDefaults standardUserDefaults]setObject:@(NO) forKey:@"isexit"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            
            MainTabBarViewController *mainCtrl=[[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"mainctrl"];
            [AppDelegate shareInstance].window.rootViewController=mainCtrl;
        }else{
             [self showErrorHUD:@"登录失败,请再试"];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self showErrorHUD:@"登录失败,请再试"];
    }];
}


@end
