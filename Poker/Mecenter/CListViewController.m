//
//  CListViewController.m
//  PKU
//
//  Created by ironfive on 16/8/11.
//  Copyright © 2016年 ironfive. All rights reserved.
//

#import "CListViewController.h"
#import "CListTableViewCell.h"

@interface CListViewController ()

@property (nonatomic,strong)NSMutableArray  *data;

@property (nonatomic,strong)NSMutableArray  *monthdata;

@end

@implementation CListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"健身记录";
    
    self.data=[NSMutableArray array];
    
    self.monthdata=[NSMutableArray array];
    
    
    self.tableView.tableFooterView=[[UIView alloc]init];
    
    [self loadData];
}

-(void)loadData
{
    [self showHUD:@"请稍等"];
    NSString *url=[NSString stringWithFormat:@"record2/%@",[UserInfoModel shareInstance].ids];
    [Http GETWithToken:url parameters:nil success:^(NSURLSessionDataTask *task, id jsonObject) {
        [self dissmissHUD];
        if ([jsonObject objectForKey:@"records"]) {
            NSArray *array=[jsonObject objectForKey:@"records"];
            
            
            NSMutableArray *da;
            
            NSDateFormatter *matter=[[NSDateFormatter alloc]init];
            [matter setDateFormat:@"MM"];
            for (int i=array.count-1;i>=0;i--) {
                NSDictionary *dic=[array objectAtIndex:i];
                NSString *money=[[[dic objectForKey:@"startTime"] description] substringWithRange:NSMakeRange(5, 2)];
                if (![self.monthdata containsObject:money]) {
                    [self.monthdata addObject:money];
                    da=[NSMutableArray array];
                    [self.data addObject:da];
                }
                [da addObject:dic];
            }
            [self.tableView reloadData];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self showErrorHUD:@"加载失败"];
    }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.monthdata.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSMutableArray *ar=[self.data objectAtIndex:section];
    return ar.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
    view.backgroundColor=[UIColor colorFromHexString:@"#f9f9f9"];
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(20,0, SCREEN_WIDTH-40, 20)];
    label.textColor=[UIColor blackColor];
    label.text=[NSString stringWithFormat:@"%@月",[self.monthdata objectAtIndex:section]];
    [view addSubview:label];
    return view;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CListTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell==nil) {
        cell=[[[NSBundle mainBundle]loadNibNamed:@"CListTableViewCell" owner:nil options:nil]lastObject];
    }
    cell.model=[[self.data objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

@end
