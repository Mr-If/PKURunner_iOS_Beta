//
//  AppDelegate.m
//  PKU
//
//  Created by ironfive on 16/8/9.
//  Copyright © 2016年 ironfive. All rights reserved.
//

#import "AppDelegate.h"

#import "LoginViewController.h"
#import "MainTabBarViewController.h"
#import "HcdGuideView.h"
#import "RunViewController.h"


//高德地图key已重制

@interface AppDelegate ()

@end

@implementation AppDelegate

+(AppDelegate *)shareInstance
{
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [NSThread sleepForTimeInterval:.5];
    
    
   self.window=[[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor=[UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    
    BOOL isexit=[[[NSUserDefaults standardUserDefaults]objectForKey:@"isexit"] boolValue];
    NSDictionary *model=[[NSUserDefaults standardUserDefaults]objectForKey:@"user"];
    if (!isexit&&model) {
        self.window.rootViewController=[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"mainctrl"];
        [UserInfoModel shareInstance].token=[model objectForKey:@"token"];
        [UserInfoModel shareInstance].pwd=[model objectForKey:@"pwd"];
        [[UserInfoModel shareInstance]setDic:model];
        
    }else{

        self.window.rootViewController=[[LoginViewController alloc] init];
    }

    [IQKeyboardManager sharedManager].enable=YES;
    
    [AMapServices sharedServices].apiKey =GAODE_MAP_KEY;
    
    [MagicalRecord setupAutoMigratingCoreDataStack];
    
//   NSArray *backgroundImageNames = @[[UIImage imageNamed:@"img_index_01bg.jpg"],[UIImage imageNamed: @"img_index_02bg.jpg"],[UIImage imageNamed: @"img_index_03bg.jpg"]];
//
//
//    
//    [[HcdGuideViewManager sharedInstance] showGuideViewWithImages:backgroundImageNames
//                                                   andButtonTitle:@"立即体验"
//                                              andButtonTitleColor:[UIColor whiteColor]
//                                                 andButtonBGColor:[UIColor clearColor]
//                                             andButtonBorderColor:[UIColor whiteColor]];
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    return YES;
}

// 本地通知回调函数，当应用程序在前台时调用
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    NSLog(@"noti:%@",notification);
    
    // 这里真实需要处理交互的地方
    // 获取通知所带的数据
    NSString *notMess = [notification.userInfo objectForKey:@"key"];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提醒"
                                                    message:notMess
                                                   delegate:nil
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
    [alert show];
    
    // 更新显示的徽章个数
    NSInteger badge = [UIApplication sharedApplication].applicationIconBadgeNumber;
    badge--;
    badge = badge >= 0 ? badge : 0;
    [UIApplication sharedApplication].applicationIconBadgeNumber = badge;
    [RunViewController cancelLocalNotificationWithKey:@"key"];
}

- (void)applicationWillResignActive:(UIApplication *)application {
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

- (void)applicationWillTerminate:(UIApplication *)application {
}

@end
