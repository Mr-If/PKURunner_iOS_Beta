//
//  BaseViewController.m
//  Runing
//
//  Created by ironfive on 16/8/9.
//  Copyright © 2016年 ironfive. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()



@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]];
    UIBarButtonItem *item=[[UIBarButtonItem alloc]init];
    item.title=@"";
    item.tintColor=[UIColor whiteColor];
    self.navigationItem.backBarButtonItem=item;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
