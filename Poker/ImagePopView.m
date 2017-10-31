//
//  ImagePopView.m
//  PKU
//
//  Created by ironfive on 17/9/20.
//  Copyright © 2017年 ironfive. All rights reserved.
//

#import "ImagePopView.h"



@interface ImagePopView()

@property (nonatomic,strong)id model;


@end

@implementation ImagePopView


-(void)awakeFromNib
{
    self.contentview.layer.cornerRadius=5;
    self.contentview.layer.masksToBounds=YES;
}

+(void)show:(id)model withShow:(BOOL)show withDelegate:(UIViewController *)ctrl
{
    ImagePopView *view=[[[NSBundle mainBundle]loadNibNamed:@"ImagePopView" owner:nil options:nil] lastObject];
    
    view.frame=CGRectMake(30, 64+40, SCREEN_WIDTH-60, SCREEN_HEIGHT-124);
    if ([model isKindOfClass:[RunInfo class]]) {
        RunInfo *m=(RunInfo *)model;
        view.icon.image=[UIImage imageWithData:m.imageData];
        view.carbtn.hidden=[m.restart boolValue];

    }else if([model isKindOfClass:[NSDictionary class]]){
        NSDictionary *m=(NSDictionary *)model;
        NSString *url=[NSString stringWithFormat:@"%@%@",BASE_URL,[[m objectForKey:@"photoPath"] description]];
        [view.icon sd_setImageWithURL:[NSURL URLWithString:url]];
        
        [view.carbtn setTitle:@"已上传到服务器" forState:UIControlStateNormal];
        view.carbtn.enabled=NO;
    }else if([model isKindOfClass:[LineInfo class]]){
        LineInfo *inf=(LineInfo *)model;
        view.icon.image=[UIImage imageWithData:inf.imageData];
        view.carbtn.hidden=[inf.restart boolValue];

    }
    view.delegate=ctrl;
    view.model=model;
    
    view.backgroundColor=[UIColor clearColor];
    
    UIView *bgview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    bgview.backgroundColor=[UIColor colorFromHexString:@"#000000" withAl:0.5];
    bgview.tag=1080;
    [[UIApplication sharedApplication].keyWindow addSubview:bgview];
    
    [[UIApplication sharedApplication].keyWindow addSubview:view];
}

- (IBAction)ClickCarBtn:(id)sender {
    [self ClickCancel:nil];
    [self.delegate restartImage:_model];
}

- (IBAction)ClickCancel:(id)sender {
    [self removeFromSuperview];
    [[[UIApplication sharedApplication].keyWindow viewWithTag:1080] removeFromSuperview];
}

@end
