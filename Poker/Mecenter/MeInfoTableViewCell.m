//
//  MeInfoTableViewCell.m
//  PKU
//
//  Created by ironfive on 16/8/30.
//  Copyright © 2016年 ironfive. All rights reserved.
//

#import "MeInfoTableViewCell.h"

@implementation MeInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setModel:(NSDictionary *)model
{
    _model=model;
    self.titlelabel.text=[[model objectForKey:INFO_KEY] description];
    NSString *value=[[model objectForKey:INFO_VALUE] description];
    if ([value isEqualToString:@"未设置"]) {
        self.valuelabel.textColor=[UIColor whiteColor];
    }else{
        self.valuelabel.textColor=[UIColor whiteColor];
    }
    self.valuelabel.text=[[model objectForKey:INFO_VALUE]description];
}

@end
