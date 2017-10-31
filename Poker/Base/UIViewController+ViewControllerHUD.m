//
//  UIViewController+ViewControllerHUD.m
//  PKU
//
//  Created by ironfive on 16/8/9.
//  Copyright © 2016年 ironfive. All rights reserved.
//

#import "UIViewController+ViewControllerHUD.h"

#import "SVProgressHUD.h"

@implementation UIViewController (ViewControllerHUD)

-(void)showHUD:(NSString *)message
{
//    [SVProgressHUD showWithStatus:message];
//    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText=message;
    
}

-(void)showSuccessHUD:(NSString *)message
{
    
//    [SVProgressHUD showSuccessWithStatus:message];
//    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
//    [SVProgressHUD dismissWithDelay:1.0];
    [MBProgressHUD hideHUD];
    [MBProgressHUD showSuccessMessage:message];
    
}

-(void)showErrorHUD:(NSString *)message
{
//    [SVProgressHUD showErrorWithStatus:message];
//    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
//    [SVProgressHUD dismissWithDelay:1.0];
    
    [MBProgressHUD hideHUD];
    
    [MBProgressHUD showErrorMessage:message];
}

-(void)dissmissHUD
{
    [MBProgressHUD hideHUD];
}

-(void)showToast:(NSString *)message
{
    [[TKAlertCenter defaultCenter]postAlertWithMessage:message];
}

-(void)addTabbar:(NSString *)nomelName withSelectName:(NSString *)selectName withTitle:(NSString *)title
{
    UITabBarItem *item=[[UITabBarItem alloc]initWithTitle:title image:[UIImage imageNamed:nomelName] selectedImage:[UIImage imageNamed:selectName]];
    self.tabBarItem=item;
}


@end
