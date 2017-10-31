//
//  NoticeViewController.m
//  PKU
//
//  Created by ironfive on 17/9/14.
//  Copyright © 2017年 ironfive. All rights reserved.
//

#import "NoticeViewController.h"

@interface NoticeViewController ()<UIAlertViewDelegate>

@end

@implementation NoticeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title=@"系统通知";
    
    
    UIAlertView *alertview=[[UIAlertView alloc]initWithTitle:@"提示" message:@"正在开发中，请期待" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alertview show];
    
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
