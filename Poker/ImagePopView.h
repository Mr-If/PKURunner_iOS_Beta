//
//  ImagePopView.h
//  PKU
//
//  Created by ironfive on 17/9/20.
//  Copyright © 2017年 ironfive. All rights reserved.
//

#import <UIKit/UIKit.h>


//typedef void(^)();

@protocol ImagePopViewDelegate <NSObject>

-(void)restartImage:(id)model;

@end


@interface ImagePopView : UIView

@property (nonatomic,assign)id<ImagePopViewDelegate>delegate;

@property (weak, nonatomic) IBOutlet UIView *contentview;

+(void)show:(id)model withShow:(BOOL)show withDelegate:(UIViewController *)ctrl;

@property (weak, nonatomic) IBOutlet UIImageView *icon;


@property (weak, nonatomic) IBOutlet UIButton *carbtn;
- (IBAction)ClickCarBtn:(id)sender;

- (IBAction)ClickCancel:(id)sender;

@end
