//
//  BaseTableViewController.m
//  PKU
//
//  Created by ironfive on 16/8/10.
//  Copyright © 2016年 ironfive. All rights reserved.
//

#import "BaseTableViewController.h"

@interface BaseTableViewController ()

@end

@implementation BaseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *item=[[UIBarButtonItem alloc]init];
    item.title=@"";
    item.tintColor=[UIColor whiteColor];
    self.navigationItem.backBarButtonItem=item;
    
    
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.jpg"]];
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.edgesForExtendedLayout=UIRectEdgeNone;
}


@end
