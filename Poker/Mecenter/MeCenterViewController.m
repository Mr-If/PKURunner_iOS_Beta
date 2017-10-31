//
//  MeCenterViewController.m
//  PKU
//
//  Created by ironfive on 16/8/10.
//  Copyright © 2016年 ironfive. All rights reserved.
//

#import "MeCenterViewController.h"

#import "RListViewController.h"

#import "CListViewController.h"

#import "LoginViewController.h"

#import "JKImagePickerController.h"

#import "MeInfoViewController.h"

#import "CalendarViewController_.h"

#import "HTMLViewController.h"

#import "NoticeViewController.h"

@interface MeCenterViewController ()<UIAlertViewDelegate,JKImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *headicon;

@property (weak, nonatomic) IBOutlet UILabel *namelabel;
@property (weak, nonatomic) IBOutlet UIButton *cancelbtu;
@property (weak, nonatomic) IBOutlet UIImageView *bgimage;


@end

@implementation MeCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"我的";
    
    self.navigationController.navigationBarHidden=YES;
    
    UIImageView *imagerview=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-49)];
    imagerview.image=[UIImage imageNamed:@"bg.jpg"];
    
    self.tableView.backgroundView=imagerview;
    self.tableView.separatorColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.jpg"]];
    
    self.headicon.backgroundColor=[UIColor redColor];
    self.headicon.layer.cornerRadius=60;
    self.headicon.layer.masksToBounds=YES;
    self.headicon.layer.borderColor=[UIColor colorFromHexString:@"#ffcc00"].CGColor;
    self.headicon.layer.borderWidth=2.0;
    self.cancelbtu.layer.cornerRadius=5;
    self.cancelbtu.layer.masksToBounds=YES;
    self.bgimage.image = [[UIImage imageNamed:@"banner1"] blurImage];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headerClick)];
    [self.headicon addGestureRecognizer:tap];
    self.headicon.userInteractionEnabled = YES;
    
    self.namelabel.text=[NSString stringWithFormat:@"name:%@  sex:%@  department%@ \n id:%@",[UserInfoModel shareInstance].name,[UserInfoModel shareInstance].sex,[UserInfoModel shareInstance].department,[UserInfoModel shareInstance].ids];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

-(void)headerClick {
    JKImagePickerController *imagePickerController = [[JKImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.showsCancelButton = YES;
    imagePickerController.isChooseHeader = YES;
    imagePickerController.allowsMultipleSelection = YES;
    //        imagePickerController.minimumNumberOfSelection = 1;
    //        imagePickerController.maximumNumberOfSelection = 9;
    UINavigationController *navigationController = [[UINavigationController alloc]initWithRootViewController:imagePickerController];
    
    
    [self presentViewController:navigationController animated:YES completion:NULL];
}

- (void)imagePickerControllerDidCancel:(JKImagePickerController *)imagePicker
{
    [imagePicker dismissViewControllerAnimated:YES completion:^{
        
    }];
}


-(void)imagePickerController:(JKImagePickerController *)imagePicker didSelectAsset:(JKAssets *)asset isSource:(BOOL)source {
    
}

- (void)imagePickerController:(JKImagePickerController *)imagePicker didSelectAssets:(NSArray *)assets isSource:(BOOL)source{
    
    __weak typeof(self) weakSelf = self;
    [imagePicker.navigationController dismissViewControllerAnimated:YES completion:^{
        
        
    }];
}

-(void)cutViewCommpelteChooseImage:(UIImage *)image viewCon:(UIViewController *)viewCon {
    __weak typeof(self) weakSelf = self;
    [viewCon.navigationController dismissViewControllerAnimated:YES completion:^{
//        weakSelf.bgimage.image = [image blurImage];
        weakSelf.headicon.image = image;
    }];
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
//    if (indexPath.section==0) {
//                MeInfoViewController *ctrl=[[MeInfoViewController alloc]initWithStyle:UITableViewStyleGrouped];
//                ctrl.hidesBottomBarWhenPushed=YES;
//                [self.navigationController pushViewController:ctrl animated:YES];
//    }
//    
    if (indexPath.section==1&&indexPath.row==0) {
        RListViewController *ctrl=[[RListViewController alloc]initWithStyle:UITableViewStylePlain];
        ctrl.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:ctrl animated:YES];
    }
  
    if (indexPath.section==1&&indexPath.row==1) {
        NoticeViewController *ctrl=[[NoticeViewController alloc]initWithStyle:UITableViewStylePlain];
        ctrl.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:ctrl animated:YES];
    }
    
    if (indexPath.section==1&&indexPath.row==2) {
//        CListViewController *ctrl=[[CListViewController alloc]initWithStyle:UITableViewStylePlain];
//        ctrl.hidesBottomBarWhenPushed=YES;
//        [self.navigationController pushViewController:ctrl animated:YES];
        
       CalendarViewController_ *ctrl=[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"calend_"];
        ctrl.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:ctrl animated:YES];
    }

    if (indexPath.section==1&&indexPath.row==3) {
        //        CListViewController *ctrl=[[CListViewController alloc]initWithStyle:UITableViewStylePlain];
        //        ctrl.hidesBottomBarWhenPushed=YES;
        //        [self.navigationController pushViewController:ctrl animated:YES];
        
        HTMLViewController *ctrl=[[HTMLViewController alloc]init];
        ctrl.url=@"http://162.105.205.61:10201/help/running_help.html";
        ctrl.title=@"跑步要求";
        ctrl.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:ctrl animated:YES];
    }

    if (indexPath.section==1&&indexPath.row==4) {
        //        CListViewController *ctrl=[[CListViewController alloc]initWithStyle:UITableViewStylePlain];
        //        ctrl.hidesBottomBarWhenPushed=YES;
        //        [self.navigationController pushViewController:ctrl animated:YES];
        
        HTMLViewController *ctrl=[[HTMLViewController alloc]init];
        ctrl.url=@"http://162.105.205.61:10201/help/basic_help.html";
        ctrl.title=@"使用说明";
        ctrl.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:ctrl animated:YES];
    }
  
    if (indexPath.section==1&&indexPath.row==5) {
        //        CListViewController *ctrl=[[CListViewController alloc]initWithStyle:UITableViewStylePlain];
        //        ctrl.hidesBottomBarWhenPushed=YES;
        //        [self.navigationController pushViewController:ctrl animated:YES];
        
        HTMLViewController *ctrl=[[HTMLViewController alloc]init];
        ctrl.url=@"http://162.105.205.61:10201/help/basic_help.html";
        ctrl.title=@"联系我们";
        ctrl.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:ctrl animated:YES];
    }
    
    if (indexPath.section==1&&indexPath.row==6) {
        //        CListViewController *ctrl=[[CListViewController alloc]initWithStyle:UITableViewStylePlain];
        //        ctrl.hidesBottomBarWhenPushed=YES;
        //        [self.navigationController pushViewController:ctrl animated:YES];
        
        HTMLViewController *ctrl=[[HTMLViewController alloc]init];
        ctrl.url=@"http://162.105.205.61:10201/help/basic_help.html";
        ctrl.title=@"关于我们";
        ctrl.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:ctrl animated:YES];
    }
    
    if (indexPath.section==1&&indexPath.row==7) {
        long size=[SDImageCache sharedImageCache].getSize;
        
        if (size<=0) {
            [self showSuccessHUD:@"很干净，不需要清理"];
        }else{
            NSString *message=[NSString stringWithFormat:@"缓存大小 %.2fM,是否清除!",size/pow(10, 6)];
            UIAlertController *ctrl=[UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancel=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            UIAlertAction *select=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self clearcatch];
                });
            }];
            [ctrl addAction:cancel];
            [ctrl addAction:select];
            [self presentViewController:ctrl animated:YES completion:NULL];
        }
    }
    
//    if (indexPath.section==1&&indexPath.row==2) {
//        MeInfoViewController *ctrl=[[MeInfoViewController alloc]initWithStyle:UITableViewStyleGrouped];
//        ctrl.hidesBottomBarWhenPushed=YES;
//        [self.navigationController pushViewController:ctrl animated:YES];
//    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)clearcatch
{
    [self showHUD:@"正在清除缓存···"];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0/*延迟执行时间*/ * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self  showSuccessHUD:@"清除成功"];
        });
    }];
}


- (IBAction)ClickCancelBtu:(id)sender {
    UIAlertView *alertview=[[UIAlertView alloc]initWithTitle:@"提示" message:@"是否删除全部本地数据并退出登录？" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
    [alertview show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {
        [self performSelector:@selector(exit) withObject:nil afterDelay:.5];
    }
}

-(void)exit
{
//    UIWindow *window = [AppDelegate shareInstance].window;
//        [UIView animateWithDuration:1.0f animations:^{
//            window.alpha = 0;
//            window.frame = CGRectMake(0, window.bounds.size.width, 0, 0);
//        } completion:^(BOOL finished) {
//            exit(0);
//        }];
    
    LoginViewController *ctrl=[[LoginViewController alloc] init];
    [AppDelegate shareInstance].window.rootViewController=ctrl;
    
    NSArray *models=[RunInfo MR_findAll];
    for (RunInfo *m in models) {
        [m MR_deleteEntity];
        [[NSManagedObjectContext MR_defaultContext]MR_saveOnlySelfAndWait];
    }
    
    [[NSUserDefaults standardUserDefaults]setObject:@(YES) forKey:@"isexit"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

@end
