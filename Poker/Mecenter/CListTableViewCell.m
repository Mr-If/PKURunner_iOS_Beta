//
//  CListTableViewCell.m
//  PKU
//
//  Created by ironfive on 16/8/11.
//  Copyright © 2016年 ironfive. All rights reserved.
//

#import "CListTableViewCell.h"

@implementation CListTableViewCell

- (void)awakeFromNib {
    self.daylabel.layer.cornerRadius=3;
    self.daylabel.layer.masksToBounds=YES;
    self.daylabel.layer.borderColor=[UIColor colorFromHexString:@"#ff5d47"].CGColor;
    self.daylabel.backgroundColor=[UIColor colorFromHexString:@"#ff5d47"];
    self.daylabel.layer.borderWidth=1.0;
}

-(void)setModel:(NSDictionary *)model
{
    _model=model;
    
    NSString *day=[[[model objectForKey:@"startTime"] description] substringWithRange:NSMakeRange(8, 2)];
    self.daylabel.text=[NSString stringWithFormat:@"%@",day];
    NSInteger place=[[model objectForKey:@"place"] integerValue]+1;
    NSString *name=[NSString stringWithFormat:@"banner%d",place];
    self.icon.image=[UIImage imageNamed:name];
    NSInteger duration=[[model objectForKey:@"duration"] integerValue];
    NSString *startTime=[NSString stringWithFormat:@"%02d:%02d:%02d",duration/60/60%24,duration/60%60,duration%60];
    self.timelabel.text=startTime;
}

@end
