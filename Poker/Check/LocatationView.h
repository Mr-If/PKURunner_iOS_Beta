//
//  LocatationView.h
//  PKU
//
//  Created by ironfive on 16/8/10.
//  Copyright © 2016年 ironfive. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LocatationViewDelegate <NSObject>

@optional
-(void)ClickCancel;
-(void)ClickSelect:(NSInteger)index;

@end

@interface LocatationView : UIView

- (IBAction)ClickCancel:(id)sender;

- (IBAction)ClickTrueBtu:(id)sender;

@property (nonatomic,assign)id<LocatationViewDelegate>delegate;

@property (weak, nonatomic) IBOutlet UIPickerView *picker;

@end
