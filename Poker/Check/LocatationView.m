//
//  LocatationView.m
//  PKU
//
//  Created by ironfive on 16/8/10.
//  Copyright © 2016年 ironfive. All rights reserved.
//

#import "LocatationView.h"

@interface LocatationView ()<UIPickerViewDataSource,UIPickerViewDelegate>

@end

@implementation LocatationView

-(void)awakeFromNib
{
    _picker.dataSource=self;
    _picker.delegate=self;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 5;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return 100;
    
}
//设置组件中每行的高度
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 40;
}
//设置组件中每行的标题row:行
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if(row==0){
        return @"健身";
    }
    if(row==1){
        return @"游泳";
    }
    if(row==2){
        return @"羽毛球";
    }
    if(row==3){
        return @"乒乓球";
    }
    if(row==4){
        return @"其他";
    }
    
    return nil;
}

- (IBAction)ClickCancel:(id)sender {
    [self.delegate ClickCancel];
}

- (IBAction)ClickTrueBtu:(id)sender {
    [self.delegate ClickSelect:[self.picker selectedRowInComponent:0]];
}
@end
