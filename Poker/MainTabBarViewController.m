//
//  MainTabBarViewController.m
//  PKU
//
//  Created by ironfive on 16/8/9.
//  Copyright © 2016年 ironfive. All rights reserved.
//

#import "MainTabBarViewController.h"

@interface MainTabBarViewController ()

@end

@implementation MainTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    self.tabBar.tintColor=[UIColor colorFromHexString:@"#ffffff"];
    [[UITabBar appearance] setBarTintColor:[UIColor colorFromHexString:@"#535353"]];
    [UITabBar appearance].translucent=NO;
    
    self.selectedIndex=1;
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
