//
//  RListViewController.m
//  PKU
//
//  Created by ironfive on 16/8/10.
//  Copyright © 2016年 ironfive. All rights reserved.
//

#import "RListViewController.h"
#import "RListTableViewCell.h"
#import "RunInfoModel.h"
#import "RunDetailViewController.h"
#import "HVideoViewController.h"


#import "PKUiAAA_iOS/PKUiAAA_Authen.h"


@interface RListViewController ()<UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,ImagePopViewDelegate,UIAlertViewDelegate,PKUOpenAPIDelegate>

@property (nonatomic,strong)NSMutableArray  *data;

@property (nonatomic,strong)NSMutableArray  *headerdata;

@property (nonatomic,strong)id  selectModel;

@property (nonatomic,strong)id  verModel;

@property (nonatomic,strong)RunInfo  *deleteModel;

@property (nonatomic,strong)NSIndexPath  *deleteIndexPath;


@end

@implementation RListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"跑步记录";
//    self.view.backgroundColor=[UIColor blackColor];
    UIImageView *imagerview=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-49)];
    imagerview.image=[UIImage imageNamed:@"bg.jpg"];
    
    self.tableView.backgroundView=imagerview;
    self.tableView.separatorColor=[UIColor whiteColor];
    
    self.tableView.tableFooterView=[[UIView alloc]init];
    
        _data=[NSMutableArray array];
    _headerdata=[NSMutableArray array];
//
//    
//    NSMutableArray *data_info=nil;
//    for (RunInfoModel *info in array) {
//        NSDateFormatter *matter=[[NSDateFormatter alloc]init];
//        [matter setDateFormat:@"MM"];
//        NSDate *date=[NSDate dateWithTimeIntervalSince1970:info.endtime];
//        NSString *month=[matter stringFromDate:date];
//        if (![_headerdata containsObject:month]) {
//            [_headerdata addObject:month];
//            data_info=[NSMutableArray array];
//            [self.data addObject:data_info];
//        }
//        [data_info addObject:info];
//    }
    
    
//    [self loadData];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    
    [self.tableView addHeaderWithCallback:^{
        [self loadData];
    }];
    
//    [self.tableView headerBeginRefreshing];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadData];
}

-(void)loadData
{
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"userid==%@",[UserInfoModel shareInstance].ids];
    
    NSArray *array=[RunInfo MR_findAllWithPredicate:predicate];
    
    NSMutableArray *infoarray=[NSMutableArray array];
    [infoarray addObjectsFromArray:array];
//    for(RunInfo *info in array) {
//        RunInfoModel *model=[[RunInfoModel alloc]init];
//        model.time=[info.time longLongValue];
//        model.userid=info.userid;
//        model.isver=[info.isver boolValue];
//        model.distance=[info.distance longLongValue];
//        model.speed=[info.speed longLongValue];
//        model.array=info.array;
//        model.endtime=[info.endtime longLongValue];
//        model.index=[info.index integerValue];
//        model.photoFilename=info.photoFilename;
//        model.imageData=info.imageData;
//        model.true_array=info.tureline;
//        [infoarray addObject:model];
//    }
    
    NSString *urlstr=[NSString stringWithFormat:@"record/%@",[UserInfoModel shareInstance].ids];
    [Http GETWithToken:urlstr parameters:nil success:^(NSURLSessionDataTask *task, id jsonObject) {
        
        [self.tableView headerEndRefreshing];
        
        [self.data removeAllObjects];
        [self.headerdata removeAllObjects]; 
        
        if ([jsonObject objectForKey:@"data"]) {
            NSArray *array=[jsonObject objectForKey:@"data"];

            NSMutableArray *arr=[NSMutableArray array];
            
            NSMutableArray *total=[NSMutableArray array];
            [total addObjectsFromArray:infoarray];
            for (NSDictionary *dic in array) {
                BOOL have=NO;
                NSInteger recordId=[[dic objectForKey:@"recordId"] integerValue];
                for (RunInfo *model in total) {
                    if ([model.index integerValue]==recordId) {
                        have=YES;
                        break;
                    }
                }

                if (!have) {
                    [arr addObject:dic];
                }
                
            }
            [total addObjectsFromArray:arr];
         array=[total sortedArrayUsingComparator:^NSComparisonResult(id   obj1, id   obj2) {
             
             NSInteger ob;
             NSInteger obj;
             
             if ([obj1 isKindOfClass:[RunInfo class]]) {
                 RunInfo *model=(RunInfo *)obj1;
                 ob=[model.index integerValue];
             }else{
                 ob=[[obj1 objectForKey:@"recordId"] integerValue];
             }
             
             if ([obj2 isKindOfClass:[RunInfo class]]) {
                 RunInfo *model=(RunInfo *)obj1;
                 obj=[model.index integerValue];
             }else{
                 obj=[[obj2 objectForKey:@"recordId"] integerValue];
             }
             
             
             if (ob>obj) {
                  return NSOrderedAscending;
             }else{
                  return NSOrderedDescending;
             }
         }];
            
            NSMutableArray *da;
            for (int i=0;i<array.count;i++) {
                id dic=[array objectAtIndex:i];
                
                if ([dic isKindOfClass:[RunInfo class]]) {
                    RunInfo *info=(RunInfo *)dic;
                    NSDateFormatter *matter=[[NSDateFormatter alloc]init];
                    [matter setDateFormat:@"yyyy-MM"];
                    NSDate *date=[NSDate dateWithTimeIntervalSince1970:[info.endtime longLongValue]];
                    NSString *month=[matter stringFromDate:date];
                    if (![self.headerdata containsObject:month]) {
                        [self.headerdata addObject:month];
                        da=[NSMutableArray array];
                        [self.data addObject:da];
                    }
                }else{
                    NSString *month=[[[dic objectForKey:@"date"] description] substringToIndex:7];
                    if (![self.headerdata containsObject:month]) {
                        [self.headerdata addObject:month];
                        da=[NSMutableArray array];
                        [self.data addObject:da];
                    }
                }
                [da addObject:dic];
            }
            [self.tableView reloadData];
//            [self showSuccessHUD:@"加载成功"];
        }else{
            [self showErrorHUD:@"加载失败"];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self.tableView headerEndRefreshing];
        [self showErrorHUD:@"加载失败"];
    }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _headerdata.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSMutableArray *array=[self.data objectAtIndex:section];
    return array.count;
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

    NSDateFormatter *matter=[[NSDateFormatter alloc]init];
    [matter setDateFormat:@"yyyy-MM"];
    
    NSDate *date=[matter dateFromString:_headerdata[section]];
    [matter setDateFormat:@"yyyy年MM月"];
    
    
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
    view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.jpg"]];
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(10,0, SCREEN_WIDTH-40, 20)];
    label.textColor=[UIColor whiteColor];
    label.text=[matter stringFromDate:date];
    [view addSubview:label];
    return view;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RListTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell==nil) {
        cell=[[[NSBundle mainBundle]loadNibNamed:@"RListTableViewCell" owner:nil options:nil]lastObject];
        cell.backgroundColor=[UIColor clearColor];
        cell.contentView.backgroundColor=[UIColor clearColor];
    }
    cell.model=[[self.data objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    cell.photoDataBlock=^(id model){
        [self showPhoto:model];
    };
    cell.verBlock=^(id model){
        [self verBtn:model];
    };
    return cell;
}

-(void)verBtn:(id)model
{
    _verModel=model;
    if ([_verModel isKindOfClass:[RunInfo class]]) {
         RunInfo *m=(RunInfo *)_verModel;
        if (m.photoFilename.length<=0) {
            UIAlertView *alertview=[[UIAlertView alloc]initWithTitle:@"提示" message:@"照片可能会影响验证结果，是否继续？" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
            [alertview show];
        }else{
            [self commitVer];
        }
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (alertView.tag==1080) {
        if (buttonIndex==1) {
            [_deleteModel MR_deleteEntity];
            [[NSManagedObjectContext MR_defaultContext] MR_saveOnlySelfAndWait];
            NSMutableArray *array=[self.data objectAtIndex:_deleteIndexPath.section];
            [array removeObject:_deleteModel];
            [self.tableView reloadData];
        }
        
        return;
    }
    
//    if (alertView.tag==2016) {
//        UITextField *nameField = [alertView textFieldAtIndex:0];
//        NSString *password=nameField.text;
//        if ([[MD5Encode md5HexDigest:password] isEqualToString:[UserInfoModel shareInstance].pwd]) {
//            [self performSelector:@selector(uploadCoor2d) withObject:nil afterDelay:.5];
//        }else{
////            [MBProgressHUD showErrorMessage:@"密码输入错误"];
//            
////            [self commitVer];
//        }
//        return;
//    }
    
    
    if (buttonIndex==1) {
        [self showPhoto:_verModel];
    }else{
        [self commitVer];
    }
}

-(void)uploadCoor2d
{
    
    RunInfo *m=(RunInfo *)_verModel;
    
    double dis=[m.distance doubleValue];
    NSArray *_tureline=[NSKeyedUnarchiver unarchiveObjectWithData:m.tureline];
    NSString *detailstr=[_tureline JSONString];
    NSDate *date=[NSDate dateWithTimeIntervalSince1970:[m.endtime longLongValue]];
    
    NSDictionary *misc=@{@"agent":@"iOS 0.9.1"};
    
    NSDictionary *params=@{@"misc":[misc JSONString],@"type":@(0),@"detail":detailstr,@"userId":[UserInfoModel shareInstance].ids,@"distance":@(dis),@"duration":@([m.time integerValue]),@"date":date,@"step":m.step};//,@"photo":m.imageData};
    NSString *url=[NSString stringWithFormat:@"record/%@",[UserInfoModel shareInstance].ids];
    
    NSArray *images=@[];
    
    if(!m.imageData){
        images=nil;
    }else{
        images=@[[UIImage imageWithData:m.imageData]];
    }
    
    [Http POST:url parameters:params images:images success:^(NSURLSessionDataTask *task, id responseObject) {
        [self dissmissHUD];
        NSDictionary *json=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        if([[json objectForKey:@"success"] boolValue]){

            m.isver=@(1);
            [m MR_deleteEntity];
            [[NSManagedObjectContext MR_defaultContext] MR_saveOnlySelfAndWait];
            
//            [self.tableView reloadData];
            
            [self loadData];
            RunDetailViewController *ctrl=[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"rundetail"];
            
            ctrl.index=[[[json objectForKey:@"data"]objectForKey:@"recordId"] integerValue];
            
            ctrl.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:ctrl animated:YES];
            
            
        }else{
            [self showErrorHUD:@"验证失败"];
        }

    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self showErrorHUD:@"验证失败"];
    }];
}

-(void)commitVer
{
//    UIAlertView *alertview=[[UIAlertView alloc]initWithTitle:@"请输入传输密码" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//    [alertview setAlertViewStyle:UIAlertViewStyleSecureTextInput];
//    UITextField *nameField = [alertview textFieldAtIndex:0];
//    nameField.textAlignment=NSTextAlignmentCenter;
//    alertview.tag=2016;
//    [alertview show];
    
    
    PKUOpenAPI *testController = [[PKUOpenAPI alloc]init];
    
    testController.delegate = self;
    
    testController.appID = @"PKU_Runner";
    
    [self presentViewController:testController animated:YES completion:nil];
}

-(void)authenticateSuccess: (NSString*) uid withToken: (NSString*)token {
    
    
    [self showHUD:@"验证中..."];
    
    [UserInfoModel shareInstance].token=token;
    [UserInfoModel shareInstance].ids=uid;
    
    [self loginVer];
    
    [UIView setAnimationsEnabled:YES];
    
}

-(void)authenticateCancel{
    [self showErrorHUD:@"取消验证"];
}

-(void)loginVer
{
    NSDictionary *params=@{@"access_token":[UserInfoModel shareInstance].token};
    [Http POST:@"user" parameters:params success:^(NSURLSessionDataTask *task, id jsonObject) {
        
        if([[jsonObject objectForKey:@"success"] boolValue]){
//            [self dissmissHUD];
            [[UserInfoModel shareInstance] setDic:jsonObject];
//            [jsonObject setObject:[UserInfoModel shareInstance].pwd forKey:@"pwd"];
            [jsonObject setObject:[UserInfoModel shareInstance].token forKey:@"token"];
            [[NSUserDefaults standardUserDefaults]setObject:jsonObject forKey:@"user"];
            [[NSUserDefaults standardUserDefaults]setObject:@(NO) forKey:@"isexit"];
            [[NSUserDefaults standardUserDefaults]synchronize];

            [self uploadCoor2d];
            
        }else{
            [self showErrorHUD:@"验证失败"];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self showErrorHUD:@"验证失败,请再试"];
    }];
}



-(void)showPhoto:(id)model
{
    _selectModel=model;
    
    if ([_selectModel isKindOfClass:[RunInfo class]]) {
        RunInfo *m=(RunInfo *)_selectModel;
        if (m.photoFilename.length<=0) {
            [self showSelectPhoto];
        }else{
            [ImagePopView show:m withShow:YES withDelegate:self];
        }
    }else{
        
        NSPredicate *predicate=[NSPredicate predicateWithFormat:@"index==%d AND userid==%@", [[_selectModel objectForKey:@"recordId"] integerValue],[UserInfoModel shareInstance].ids];
        LineInfo *info=[[LineInfo MR_findAllWithPredicate:predicate inContext:[NSManagedObjectContext MR_defaultContext]] lastObject];
        
        if (info==nil&&[[_selectModel objectForKey:@"photoPath"] description].length<=0) {
            [self showSelectPhoto];
        }else{
            if (info) {
                [ImagePopView show:info withShow:YES withDelegate:self];
            }else{
                [ImagePopView show:_selectModel withShow:YES withDelegate:self];
            }
        }
        
        
//        if ([[_selectModel objectForKey:@"photoFilename"] description].length<=0) {
//            [self showSelectPhoto];
//        }else{
//            
//            if (info) {
//            [ImagePopView show:info withShow:YES withDelegate:self];
//            }else{
//                [ImagePopView show:_selectModel withShow:YES withDelegate:self];
//            }
//            
//            
//        }
    }
    

}

//static NSInteger restart=0;

-(void)restartImage:(id)model
{
    _selectModel=model;
    UIImagePickerController *ctrl=[[UIImagePickerController alloc]init];
    ctrl.sourceType=UIImagePickerControllerSourceTypePhotoLibrary|UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    ctrl.delegate=self;
    [self presentViewController:ctrl animated:YES completion:NULL];
}

-(void)showSelectPhoto
{
    UIActionSheet *sheet=[[UIActionSheet alloc]initWithTitle:@"现在拍摄还是选择已有照片？" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"现在拍摄" otherButtonTitles:@"已有照片", nil];
    [sheet showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        HVideoViewController *ctrl = [[NSBundle mainBundle] loadNibNamed:@"HVideoViewController" owner:nil options:nil].lastObject;
        ctrl.HSeconds = 30;//设置可录制最长时间
        ctrl.takeBlock = ^(id item) {
            if ([item isKindOfClass:[NSURL class]]) {
                NSURL *videoURL = item;
                //视频url
                
            } else {
                //图片
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self recoderImage:item];
                });
                
            }
        };
        [self presentViewController:ctrl animated:YES completion:nil];
    }else if (buttonIndex==1){
        UIImagePickerController *ctrl=[[UIImagePickerController alloc]init];
        ctrl.sourceType=UIImagePickerControllerSourceTypePhotoLibrary|UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        ctrl.delegate=self;
        [self presentViewController:ctrl animated:YES completion:NULL];
    }
}

-(void)recoderImage:(UIImage *)image
{
    if ([_selectModel isKindOfClass:[RunInfo class]]) {
        RunInfo *m=(RunInfo *)_selectModel;
        
        if(m.imageData){
            m.restart=@(1);
        }else{
            m.restart=@(0);
        }
        
        m.imageData=[self getZomeImageData:image];
        m.photoFilename=@"123.png";
        
        if ([m.restart integerValue]==1) {
            [self showToast:@"已重新拍摄"];
        }
        
        [[NSManagedObjectContext MR_defaultContext]MR_saveOnlySelfAndWait];
        [self.tableView reloadData];
        _selectModel=nil;
    }else if([_selectModel isKindOfClass:[NSDictionary class]]){
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self saveImageData:image];
        });
    }else if([_selectModel isKindOfClass:[LineInfo class]]){
        LineInfo *m=(LineInfo *)_selectModel;
        
        if(m.imageData){
            m.restart=@(1);
        }else{
            m.restart=@(0);
        }
        
        m.imageData=[self getZomeImageData:image];
        //        m.photoFilename=@"123.png";
        
        if ([m.restart integerValue]==1) {
            [self showToast:@"已重新拍摄"];
        }
        
        [[NSManagedObjectContext MR_defaultContext]MR_saveOnlySelfAndWait];
        [self.tableView reloadData];
        
    }
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
    UIImage *image=[info objectForKey:@"UIImagePickerControllerOriginalImage"];
    if ([_selectModel isKindOfClass:[RunInfo class]]) {
        RunInfo *m=(RunInfo *)_selectModel;
        
        if(m.imageData){
            m.restart=@(1);
        }else{
            m.restart=@(0);
        }
        
        m.imageData=[self getZomeImageData:image];
        m.photoFilename=@"123.png";
        
        if ([m.restart integerValue]==1) {
            [self showToast:@"已重新拍摄"];
        }
        
        [[NSManagedObjectContext MR_defaultContext]MR_saveOnlySelfAndWait];
        [self.tableView reloadData];
        _selectModel=nil;
    }else if([_selectModel isKindOfClass:[NSDictionary class]]){

        dispatch_async(dispatch_get_main_queue(), ^{
            [self saveImageData:image];
        });
    }else if([_selectModel isKindOfClass:[LineInfo class]]){
        LineInfo *m=(LineInfo *)_selectModel;
        
        if(m.imageData){
            m.restart=@(1);
        }else{
            m.restart=@(0);
        }
        
        m.imageData=[self getZomeImageData:image];
        if ([m.restart integerValue]==1) {
            [self showToast:@"已重新拍摄"];
        }
        
        [[NSManagedObjectContext MR_defaultContext]MR_saveOnlySelfAndWait];
        [self.tableView reloadData];

    }
    
}

-(void)saveImageData:(UIImage *)image
{
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"index==%d && userid==%@", [[_selectModel objectForKey:@"recordId"] integerValue],[UserInfoModel shareInstance].ids];

    LineInfo *info=[[LineInfo MR_findAllWithPredicate:predicate] lastObject];
    
    if (info==nil) {
        info=[LineInfo MR_createEntity];
        info.restart=@(0);
    }else{
        info.restart=@(1);
    }
    [self.tableView reloadData];
    
    if ([info.restart integerValue]==1) {
        [self showToast:@"已重新拍摄"];
    }
    
    info.userid=[UserInfoModel shareInstance].ids;
    info.index=@([[_selectModel objectForKey:@"recordId"] integerValue]);
    info.imageData=[self getZomeImageData:image];
    [[NSManagedObjectContext MR_defaultContext]MR_saveOnlySelfAndWait];
    _selectModel=nil;
}

-(NSData *)getZomeImageData:(UIImage *)image
{
//    NSData *data=UIImageJPEGRepresentation(image, 0.2);
//    return data;
    
    
//    - (NSData *)compressOriginalImage:(UIImage *)image toMaxDataSizeKBytes:(CGFloat)size{
        NSData * data = UIImageJPEGRepresentation(image, 1.0);
        CGFloat dataKBytes = data.length/1000.0;
        CGFloat maxQuality = 0.9f;
        CGFloat lastData = dataKBytes;
        while (dataKBytes > 500 && maxQuality > 0.01f) {
            maxQuality = maxQuality - 0.01f;
            data = UIImageJPEGRepresentation(image, maxQuality);
            dataKBytes = data.length / 1000.0;
            if (lastData == dataKBytes) {
                break;
            }else{
                lastData = dataKBytes;
            }  
        }  
        return data;  
//    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id model=[[self.data objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    
    RunDetailViewController *ctrl=[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"rundetail"];
    
    if ([model isKindOfClass:[RunInfo class]]) {
        RunInfo *m=(RunInfo *)model;
        ctrl.index=[m.index integerValue];
    }else{
        ctrl.index=[[model objectForKey:@"recordId"] integerValue];
    }
    
    ctrl.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:ctrl animated:YES];
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *array=[self.data objectAtIndex:indexPath.section];
    id model=[array objectAtIndex:indexPath.row];
    if ([model isKindOfClass:[RunInfo class]]) {
        return YES;
    }
    return NO;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *array=[self.data objectAtIndex:indexPath.section];
    id model=[array objectAtIndex:indexPath.row];
    if ([model isKindOfClass:[RunInfo class]]) {
        _deleteModel=model;
        _deleteIndexPath=indexPath;
        UIAlertView *alertview=[[UIAlertView alloc]initWithTitle:@"提示" message:@"是否删除" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
        alertview.tag=1080;
        [alertview show];
    }
}

@end
