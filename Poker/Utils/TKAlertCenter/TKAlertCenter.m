//
//  TKAlertCenter.m
//  TKAlertCenter
//
//  Created by 123 on 16/1/6.
//  Copyright (c) 2016年 123. All rights reserved.
//

#import "TKAlertCenter.h"

#define SCREEN_WIDTH   [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT  [UIScreen mainScreen].bounds.size.height

@interface TKAlertCenter ()

@property (nonatomic,strong)UIImageView  *bgimage;

@property (nonatomic,strong)UILabel      *messagelabel;

@end


@implementation TKAlertCenter

+(TKAlertCenter *)defaultCenter
{
    TKAlertCenter *view=[[TKAlertCenter alloc]initWithFrame:CGRectZero];
    view.tag=2000016;
    //    view.backgroundColor=[UIColor orangeColor];
    return view;
}

-(void)postAlertWithMessage:(NSString *)message
{
//    if([[UIApplication sharedApplication].keyWindow viewWithTag:2000016]){
//        return;
//    }
//    
//    CGRect rect=[message boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-100, 9999) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0f]} context:nil];
//    
//    self.frame=CGRectMake(0, 0, rect.size.width+20, rect.size.height+20);
//    
//    self.messagelabel=[[UILabel alloc]initWithFrame:CGRectMake((self.bounds.size.width-rect.size.width-2)/2.0, (self.bounds.size.height-rect.size.height-2)/2.0, rect.size.width+2, rect.size.height+2)];
//    
//    self.messagelabel.font=[UIFont systemFontOfSize:14.0f];
//    self.messagelabel.textColor=[UIColor redColor];
//    self.messagelabel.numberOfLines=0;
//    self.messagelabel.textAlignment=NSTextAlignmentCenter;
//    self.messagelabel.text=message;
//    
//    self.bgimage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width+2, self.bounds.size.height+2)];
//    UIImage *image=[UIImage imageNamed:@"提示框(1)"];
//    self.bgimage.image=image;
//    
//    
//    [self addSubview:self.bgimage];
//    [self addSubview:self.messagelabel];
//    
//    self.center=CGPointMake([UIScreen mainScreen].bounds.size.width/2.0, [UIScreen mainScreen].bounds.size.height+100);
//    [[UIApplication sharedApplication].keyWindow addSubview:self];
//    
//    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationDuration:1.0];
//    [UIView setAnimationDelegate:self];
//    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
//    [UIView setAnimationDidStopSelector:@selector(Hidden)];
//    self.center=CGPointMake([UIScreen mainScreen].bounds.size.width/2.0, [UIScreen mainScreen].bounds.size.height-self.bounds.size.height-60);
//    [UIView commitAnimations];
    
    UIAlertView *alertview=[[UIAlertView alloc]initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alertview show];
    return;
}

- (void) postAlertWithMessage:(NSString*)message image:(UIImage*)image
{
    
}

-(void)Hidden
{
    [UIView beginAnimations:nil context:nil];
    
    [UIView setAnimationDelay:1.5];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationStep3)];
    self.alpha = 0;
    [UIView commitAnimations];
}

- (void) animationStep3{
    [self removeFromSuperview];
}

@end
